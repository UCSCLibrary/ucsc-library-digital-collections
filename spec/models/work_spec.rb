require 'rails_helper'

RSpec.describe Work do

  before do
    @usr = User.create!({email:"test@test.test",password:"testpass"})
    @wrk = Work.new({title: ["test title"],
                     depositor: @usr.email})
  end

  it "can be saved with simple metadata" do
    @wrk.save
    expect !@wrk.id.nil?
  end

  it "can accept more complex metadata" do
    @wrk.description = ["a test description","another test description"]
    expect !@wrk.description.nil?
    #TODO add more test metadata fields here
  end

  it "can be saved with complex metadata" do
    @wrk.save
    expect !@wrk.id.nil?
  end

  it "persists edited metadata after saving" do
    expect !@wrk.description.nil?
  end

end
