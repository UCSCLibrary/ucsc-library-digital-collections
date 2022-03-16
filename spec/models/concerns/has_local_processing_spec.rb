# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bulkrax::HasLocalProcessing do
  let(:entry) { build(:bulkrax_csv_entry) }

  describe '#add_local' do
    it 'calls #remap_resource_type' do
      expect(entry).to receive(:remap_resource_type)
      entry.add_local
    end

    it 'calls #process_date_created_ingest' do
      expect(entry).to receive(:process_date_created_ingest)
      entry.add_local
    end

    it 'calls #add_controlled_fields' do
      expect(entry).to receive(:add_controlled_fields)
      entry.add_local
    end

    describe 'dateCreatedIngest processing' do
      context 'when dateCreatedIngest is blank' do
        before do
          entry.parsed_metadata = { 'dateCreatedIngest' => [''], 'dateCreated' => ['test'] }
        end

        it 'does not change dateCreated' do
          expect { entry.add_local }
            .not_to change { entry.parsed_metadata['dateCreated'] }
        end
      end

      context 'when dateCreatedIngest is a year (YYYY)' do
        before do
          entry.parsed_metadata = { 'dateCreatedIngest' => ['1984'], 'dateCreated' => ['test'] }
        end

        it 'converts the value to a full date and adds it to dateCreated' do
          expect(entry.parsed_metadata['dateCreated']).to eq(['test'])

          entry.add_local

          expect(entry.parsed_metadata['dateCreated']).to eq(%w[test 1984-12-31])
        end
      end

      context 'when dateCreatedIngest is a full date (YYYY-MM-DD)' do
        before do
          entry.parsed_metadata = { 'dateCreatedIngest' => ['1817-03-23'], 'dateCreated' => ['test'] }
        end

        it 'adds the full date to dateCreated' do
          expect(entry.parsed_metadata['dateCreated']).to eq(['test'])

          entry.add_local

          expect(entry.parsed_metadata['dateCreated']).to eq(%w[test 1817-03-23])
        end
      end

      context 'when dateCreatedIngest is not a valid date' do
        before do
          entry.parsed_metadata = { 'dateCreatedIngest' => ['this is not a date'], 'dateCreated' => ['test'] }
        end

        it 'raises a StandardError' do
          expect { entry.add_local }
            .to raise_error(StandardError, %("this is not a date" is not a valid date value for dateCreatedIngest))
        end
      end

      context 'when dateCreatedIngest has multiple values' do
        before do
          entry.parsed_metadata = { 'dateCreatedIngest' => %w[1984 1817-03-23], 'dateCreated' => ['test'] }
        end

        it 'adds all valid dates to dateCreated' do
          expect(entry.parsed_metadata['dateCreated']).to eq(['test'])

          entry.add_local

          expect(entry.parsed_metadata['dateCreated']).to eq(%w[test 1984-12-31 1817-03-23])
        end
      end
    end
  end

  describe '#add_rights_statement' do
    before do
      entry.parsed_metadata = { 'rights_statement' => 'http://rightsstatements.org/vocab/InC/1.0/' }
    end

    it 'remaps rights_statement to rightsStatement' do
      expect(entry.parsed_metadata['rights_statement']).to eq('http://rightsstatements.org/vocab/InC/1.0/')
      expect(entry.parsed_metadata['rightsStatement']).to be_nil

      entry.add_rights_statement

      expect(entry.parsed_metadata['rights_statement']).to be_nil
      expect(entry.parsed_metadata['rightsStatement']).to eq('http://rightsstatements.org/vocab/InC/1.0/')
    end

    context 'when a record is imported without a rights statement' do
      before do
        entry.parsed_metadata = { 'title' => 'No Rights Statement' }
      end

      it 'does not fall back on a default rights statement' do
        expect(entry.parsed_metadata['rightsStatement']).to be_nil

        entry.add_rights_statement

        expect(entry.parsed_metadata['rightsStatement']).to be_nil
      end
    end

    context 'when a record is imported with a blank rights statement' do
      before do
        entry.parsed_metadata = { 'title' => 'Blank Rights Statement', 'rights_statement' => '' }
      end

      it 'does not fall back on a default rights statement' do
        expect(entry.parsed_metadata['rightsStatement']).to be_blank

        entry.add_rights_statement

        expect(entry.parsed_metadata['rightsStatement']).to be_blank
      end
    end

    context 'when an importer is configured to override rights statements' do
      before do
        allow(entry).to receive(:override_rights_statement).and_return(true)
        allow(entry.parser).to receive(:parser_fields).and_return({ 'rights_statement' => 'http://rightsstatements.org/vocab/InC/1.0/' })
      end

      context 'when a record is imported without a rights statement' do
        before do
          entry.parsed_metadata = { 'title' => 'No Rights Statement' }
        end

        it 'falls back on a default rights statement' do
          expect(entry.parsed_metadata['rightsStatement']).to be_nil

          entry.add_rights_statement

          expect(entry.parsed_metadata['rightsStatement']).to eq(['http://rightsstatements.org/vocab/InC/1.0/'])
        end
      end

      context 'when a record is imported with a blank rights statement' do
        before do
          entry.parsed_metadata = { 'title' => 'Blank Rights Statement', 'rights_statement' => '' }
        end

        it 'falls back on a default rights statement' do
          expect(entry.parsed_metadata['rightsStatement']).to be_blank

          entry.add_rights_statement

          expect(entry.parsed_metadata['rightsStatement']).to eq(['http://rightsstatements.org/vocab/InC/1.0/'])
        end
      end
    end
  end
end
