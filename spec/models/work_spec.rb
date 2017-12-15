require 'rails_helper'

RSpec.describe Work do

  before do
    @usr = User.create!({email:"test@test.test",password:"testpass"})
    @wrk = Work.new({title: "test title",
                     depositor: @usr.email})
  end

  it "can be saved with simple metadata" do
    @wrk.save
    expect !@wrk.id.nil?
  end

  it "can accept more complex metadata" do
    @wrk.description = ["a test description","another test description"]
    expect !@wrk.description.nil?
    @wrk.accessionNumber= "11006b"
    @wrk.donorProvenance= ["some donor or provenance"]
    @wrk.dateCreated= ["2017-01-01"]
    @wrk.language= ["eng"]
    @wrk.keyword= ["test"]
  end

  it "can be saved with complex metadata" do
    @wrk.save
    expect !@wrk.id.nil?
  end

  it "persists edited metadata after saving" do
    expect !@wrk.description.nil?
    expect !@wrk.accessionNumber.nil?
    expect !@wrk.donorProvenance.nil?
    expect !@wrk.dateCreated.nil?
    expect !@wrk.language.nil?
    expect !@wrk.keyword.nil?
  end

end
