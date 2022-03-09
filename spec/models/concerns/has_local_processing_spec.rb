# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bulkrax::HasLocalProcessing do
  let(:entry) { build(:bulkrax_csv_entry) }

  describe '#add_local' do
    it 'calls #remap_resource_type' do
      expect(entry).to receive(:remap_resource_type)
      entry.add_local
    end

    it 'calls #add_controlled_fields' do
      expect(entry).to receive(:add_controlled_fields)
      entry.add_local
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
