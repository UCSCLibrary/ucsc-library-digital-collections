require 'rails_helper'

RSpec.describe Hyrax::WorksController do
  include Devise::Test::ControllerHelpers

  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#new' do
    context 'my work' do
      it 'shows me the page' do
        get :new
        expect(response).to be_success
        expect(assigns[:form]).to be_kind_of Hyrax::WorkForm
        expect(assigns[:form].depositor).to eq user.user_key
        expect(assigns[:curation_concern]).to be_kind_of Work
        expect(assigns[:curation_concern].depositor).to eq user.user_key
        expect(response).to render_template("layouts/dashboard")
      end
    end
  end

#
#  describe '#show' do
#    before do
#      create(:sipity_entity, proxy_for_global_id: work.to_global_id.to_s)
#    end
#    context 'my own private work' do
#      let(:work) { create(:private_work, user: user, title: 'test title', id: "BlahBlah1") }
#
#      it 'shows me the page' do
#        get :show, params: { id: "BlahBlah1" }
#        expect(response).to be_success
#        expect(assigns(:presenter)).to be_kind_of Hyrax::WorkShowPresenter
#      end
#
#    end
#  end
#
end
