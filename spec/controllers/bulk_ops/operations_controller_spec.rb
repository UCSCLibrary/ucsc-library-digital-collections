require 'rails_helper'

RSpec.describe BulkOps::OperationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  routes {  BulkOps::Engine.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:user) { create(:admin) }
  let(:work) { create(:work, title: ['Titacular'], with_admin_set: true) }
  let(:solr_work) { SolrDocument.find(work.id) }

  before do  
    admin = Role.find_by(name: "admin") || Role.create(name: "admin")
    admin.users << user
    admin.save
    sign_in user 
  end

  describe '#index' do
    context 'User requests the index of bulk operations' do
      it 'displays a list of operations' do
        get :index
        puts response.status_message
        puts response.message
        puts response.body
        puts response.to_a.inspect
        expect(response).to be_success
        expect(response).to render_template("bulk_ops/operations/index")
      end
    end
  end

  describe '#search' do
    it 'provides a valid response given no search parameters' do
      get :search
      expect(response).to be_success
      rsp = JSON.parse(response.body)
      expect(rsp['num_results']).to be_kind_of(Integer)
      expect(rsp['num_results']).to equal(rsp['results'].count)
    end

#    it 'can find a work by admin set name' do
#      get :search, params: {admin_set: solr_work.admin_set.first}
#      expect(response).to be_success
#      rsp = JSON.parse(response.body)
#      expect(rsp['num_results']).to be_kind_of(Integer)
#      expect(rsp['num_results']).to equal(rsp['results'].count)
#      expect(rsp['num_results']).to be > 0
#    end
#
    it 'can find a work by keyword search' do
      get :search, params: {q: "titacular"}
      expect(response).to be_success
      rsp = JSON.parse(response.body)
      expect(rsp['num_results']).to be_kind_of(Integer)
      expect(rsp['num_results']).to equal(rsp['results'].count)
      expect(rsp['num_results']).to be > 0
    end

    it 'can find a work by admin set id' do
      get :search, params: {admin_set_id: work.admin_set.id}
      expect(response).to be_success
      rsp = JSON.parse(response.body)
      expect(rsp['num_results']).to be_kind_of(Integer)
      expect(rsp['num_results']).to equal(rsp['results'].count)
      expect(rsp['num_results']).to be > 0
    end

    context 'when the work is part of a collection' do
      let(:collection) { build(:collection_lw)} 
      it 'can find a work by collection id' do
        collection.add_member_objects([work.id]);
        collection.save!
        get :search, params: {collection_id: collection.id}
        expect(response).to be_success
        rsp = JSON.parse(response.body)
        expect(rsp['num_results']).to be_kind_of(Integer)
        expect(rsp['num_results']).to equal(rsp['results'].count)
        expect(rsp['num_results']).to be > 0
      end
    end
    
    it 'can find a work by workflow_state' do
      get :search, params: {collection_id: solr_work.workflow_state}
      expect(response).to be_success
      rsp = JSON.parse(response.body)
      expect(rsp['num_results']).to be_kind_of(Integer)
      expect(rsp['num_results']).to equal(rsp['results'].count)
      expect(rsp['num_results']).to be > 0
    end
  end

end
