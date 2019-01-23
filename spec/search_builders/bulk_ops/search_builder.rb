require 'rails_helper'

RSpec.describe BulkOps::SearchBuilder do
  let(:me) {build :user}
  let(:context) { double("context", 
                         blacklight_config: CatalogController.blacklight_config,
                         current_ability: Ability.new(me),
                         current_user: me) }
  let(:solr_params) { { fq: [] } }
  let(:work) {Work.create(title:["test work"], depositor: me.email)}
#  let(:collection) { Collection.create!(title:["test_collection"], depositor: me.email)}
  let(:collection) { build(:collection, id: '12345', title:["test_collection"]) }
  let(:builder) { described_class.new(scope: context, collection: collection) }
  let(:repository) {CatalogController.new.repository}

  describe ".default_processor_chain" do
    subject { builder.default_processor_chain }

    it { is_expected.to include :member_of_collection }
    it { is_expected.to include :member_of_admin_set }
    it { is_expected.to include :in_workflow_state }
  end

  describe '#member_of_collection' do
    let(:subject) { builder.member_of_collection(solr_params) }
    it 'updates solr_parameters[:fq]' do
      subject
      expect(solr_params[:fq]).to include("#{builder.collection_field}:#{collection.title.first}")
    end
  end

  describe 'query' do
    let(:query) { builder.query }
    it 'produces some form of query' do
      query
      expect(query.is_a?(String))
    end
    it 'includes the collection id in the query' do
      query
      expect(query.include? collection.id)
    end
  end

  describe 'response to collection query' do
    context 'no works are part of the collection' do
      let(:response_documents) {repository.search(builder).documents}
      it 'returns no results' do
        expect(response_documents).to be_empty
      end
    end
    context 'a work is part of the collection' do
      let (:full_collection) {collection.members << work;collection.save;collection}
      let (:full_collection_builder) {described_class.new(scope: context, collection: collection) }
      let(:response_documents) {repository.search(full_collection_builder).documents}
      it 'returns one result' do
        work.save
        expect(response_documents.count).to eq(1)
      end
    end
    
  end

end
