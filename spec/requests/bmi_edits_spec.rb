require 'rails_helper'

RSpec.describe "BmiEdits", type: :request do
  describe "GET /bmi_edits" do
    it "works! (now write some real specs)" do
      get bmi_edits_path
      expect(response).to have_http_status(200)
    end
  end
end
