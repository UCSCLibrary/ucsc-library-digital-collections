require 'rails_helper'

RSpec.describe Hyrax::WorksController do
  include Devise::Test::ControllerHelpers

  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }
  let(:user) { create(:user) }
  let(:work) { create(:work) }

  after(:all) do
    Work.all.each{|wrk| wrk.destroy}
    User.all.each{|usr| usr.destroy}
  end

  before do 
    sign_in user 
  end

  describe '#new' do
    context 'my work' do
      it 'shows me the page' do
        get :new
        expect(response).to be_success
        expect(assigns[:form]).to be_kind_of Hyrax::WorkForm
        expect(assigns[:form].depositor).to eq user.user_key
        expect(assigns[:curation_concern]).to be_kind_of Work
        expect(assigns[:curation_concern].depositor).to eq user.user_key
        expect(response).to render_template("layouts/hyrax/dashboard")
      end
    end
  end

#  describe '#edit' do
#    context 'my own private work' do
#      let(:work) { create(:private_work, user: user) }
#
#      it 'shows me the page and sets breadcrumbs' do
#        expect(controller).to receive(:add_breadcrumb).with("Home", root_path(locale: 'en'))
#        expect(controller).to receive(:add_breadcrumb).with("Administration", hyrax.dashboard_path(locale: 'en'))
#        expect(controller).to receive(:add_breadcrumb).with("Your Works", hyrax.my_works_path(locale: 'en'))
#        expect(controller).to receive(:add_breadcrumb).with(work.title.first, main_app.hyrax_work_path(work.id, locale: 'en'))
#        expect(controller).to receive(:add_breadcrumb).with('Edit', main_app.edit_hyrax_work_path(work.id))
#
#        get :edit, params: { id: work. }
#        expect(response).to be_success
#        expect(assigns[:form]).to be_kind_of Hyrax::GenericWorkForm
#        expect(response).to render_template("layouts/hyrax/dashboard")
#      end
#    end
#  end
#
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
