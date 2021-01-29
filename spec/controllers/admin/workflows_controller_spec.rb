require 'rails_helper'

RSpec.describe Admin::WorkflowsController do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:admin) { (admin = (Role.find_by(name: "admin") || Role.create(name: "admin"))).users << user; admin.save; user}

  describe "index" do
    it "does not display for the public" do
      sign_in admin
      expect(response).not_to render_template('hyrax/admin/workflows/index')
    end

    it "shows possible workflow states" do
      sign_in admin
      get :index
      expect(response).to be_successful
      expect(response).to render_template('hyrax/admin/workflows/index')
      expect(response).to render_template('layouts/hyrax/dashboard')
    end
  end
end
