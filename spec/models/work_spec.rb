require 'rails_helper'

RSpec.describe Work do

  before do
    @usr = User.create!({email:"test@test.test",password:"testpass"})
#    @wrk = Work.new({title: "test title",
    @wrk = Work.new({title: ["test title"],
                     depositor: @usr.email})
  end

  it "can be saved with simple metadata" do
    @wrk.save
    expect !@wrk.id.nil?
  end

  it "can accept more complex metadata" do
    @wrk.description = ["a test description","another test description"]
#    @wrk.accessionNumber= "11006b"
    @wrk.accessionNumber= ["11006b"]
    @wrk.donorProvenance= ["some donor or provenance"]
    @wrk.dateCreated= ["2017-01-01"]
    @wrk.language= ["eng"]
    @wrk.keyword= ["test"]
    expect !@wrk.description.nil?
  end

  it "can be saved with complex metadata" do
    @wrk.save
    expect !@wrk.id.nil?
#    expect !@wrk.description.empty?
  end

  it "persists edited metadata after saving" do
    expect !@wrk.description.nil?
    expect !@wrk.accessionNumber.nil?
    expect !@wrk.donorProvenance.nil?
    expect !@wrk.dateCreated.nil?
    expect !@wrk.language.nil?
    expect !@wrk.keyword.nil?
  end

  it "has all metadata properties defined as methods" do
    expect(@wrk.methods).to include(*ScoobySnacks::METADATA_SCHEMA.fields.keys.map{|key| key.to_sym})
  end

  it "has controlled properties properly defined" do
    expect(@wrk.methods).to include(*ScoobySnacks::METADATA_SCHEMA.controlled_field_names.map{|field_name| "#{field_name}_attributes=".to_sym })
  end

end
