require 'rails_helper'

RSpec.describe Hyrax::HomepageController do
  include Devise::Test::ControllerHelpers

  describe "index" do
    it "displays feature collections" do
      get :index
      expect(response).to be_successful
      expect(response).to render_template('hyrax/homepage/index')
      expect(response).to render_template('layouts/homepage')
    end
  end
end
