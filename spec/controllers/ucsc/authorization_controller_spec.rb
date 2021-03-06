require 'rails_helper'

RSpec.describe Ucsc::AuthorizationController do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:admin) { (admin = (Role.find_by(name: "admin") || Role.create(name: "admin"))).users << user; admin.save; user}
  let(:work) { create(:work) }
  
  describe "authorize" do

    it "reports that public may view public work" do
      work.visibility = "open"
      work.save
      get :authorize, params: { id: work.id }
      expect(response).to be_successful
      expect(response.body).to include("Access Granted")
    end

    it "reports that public may not view unauthorized work" do
      work.visibility = "restricted"
      work.save
      get :authorize, params: { id: work.id }
      expect(response).not_to be_successful
      expect(response.body).to include("FORBIDDEN")
    end

    it "reports that admin user may view unauthorized work" do
      work.visibility = "restricted"
      work.save
      sign_in admin
      get :authorize, params: { id: work.id }
      expect(response).to be_successful
      expect(response.body).to include("Access Granted")
    end

  end
end
