require 'rails_helper'

RSpec.describe BulkMetadata::IngestsController do
  include Devise::Test::ControllerHelpers

  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }
  let(:user) { create(:user) }
  let(:work) { create(:work) }

  before do 
    sign_in user 
  end

  describe '#new' do
    context 'ingest request' do
      it 'shows me the ingest creation page' do
        get :new
        expect(response).to be_success
        expect(response).to render_template("layouts/dashboard")
      end
    end
  end


  describe '#show' do
    context 'an existing ingest' do
      it 'shows me the ingest' do
        get :show, params: {id: work.id}
        expect(response).to be_success
        expect(response).to render_template("layouts/dashboard")
      end
    end
  end



end
