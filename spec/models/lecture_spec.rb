require 'rails_helper'

RSpec.describe Lecture do


  before do
    @usr = User.create!({email:"test@test.test",password:"testpass"})
    @lec = Lecture.new({title: ["test title"],
                     depositor: @usr.email})
  end

  it "can be saved with simple metadata" do
    @lec.save
    expect !@lec.id.nil?
  end

  it "can accept more complex metadata" do
    @lec.description = ["a test description","another test description"]
    expect !@lec.description.nil?
    #TODO add more test metadata fields here
  end

  it "can be saved with complex metadata" do
    @lec.save
    expect !@lec.id.nil?
  end

  it "persists edited metadata after saving" do
    expect !@lec.description.nil?
  end



end
