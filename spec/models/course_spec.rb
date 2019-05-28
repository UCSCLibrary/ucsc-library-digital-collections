# Generated via
#  `rails generate hyrax:work Course`
require 'rails_helper'

RSpec.describe Course do

  before(:all) do
    @usr = User.create(email:"test user email")
    @crs = Course.new({title: ["test title"],
                     depositor: @usr.email})
  end

  after(:all) do
    @crs.destroy
  end

  it "can be saved with simple metadata" do
    @crs.save
    expect !@crs.id.nil?
  end

  it "can accept more complex metadata" do
    @crs.description = ["a test description","another test description"]
    expect !@crs.description.nil?
    #TODO add more test metadata fields here
  end

  it "can be saved with complex metadata" do
    @crs.save
    expect !@crs.id.nil?
  end

  it "persists edited metadata after saving" do
    expect !@crs.description.nil?
  end

end
