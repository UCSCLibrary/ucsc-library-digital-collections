require "rails_helper"

RSpec.describe BmiEditsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bmi_edits").to route_to("bmi_edits#index")
    end

    it "routes to #new" do
      expect(:get => "/bmi_edits/new").to route_to("bmi_edits#new")
    end

    it "routes to #show" do
      expect(:get => "/bmi_edits/1").to route_to("bmi_edits#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bmi_edits/1/edit").to route_to("bmi_edits#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bmi_edits").to route_to("bmi_edits#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bmi_edits/1").to route_to("bmi_edits#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bmi_edits/1").to route_to("bmi_edits#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bmi_edits/1").to route_to("bmi_edits#destroy", :id => "1")
    end

  end
end
