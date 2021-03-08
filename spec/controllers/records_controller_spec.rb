require 'rails_helper'

RSpec.describe RecordsController do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:work) { create(:work) }
  let(:collection) { ::Collection.create(depositor: user.email, title: ["test collection"], collection_type: Hyrax::CollectionType.find_or_create_default_collection_type) }
  
  describe "authorize" do
    context "a work permalink" do
      it "redirects to actual link" do
        get :show, params: { id: work.id }
        expect(response).to redirect_to "/concern/works/#{work.id}"
      end
    end

    context "a collection permalink" do
      it "redirects to actual link" do
        get :show, params: { id: collection.id }
        expect(response).to redirect_to "/collections/#{collection.id}"
      end
    end

  end
end
