require 'rails_helper'

RSpec.describe Work do
  let(:usr) {User.find_by_email('test-email') || User.create(email:"test-email")}
  let(:schema) {ScoobySnacks::METADATA_SCHEMA}
  let(:simple_inheritable_field_name) {(schema.inheritable_field_names - schema.controlled_field_names).first}
  let(:complex_inheritable_field_name) {(schema.inheritable_field_names & schema.controlled_field_names).first}
  let(:non_inheritable_field_name) {(schema.all_field_names - schema.controlled_field_names - schema.inheritable_field_names).first}
  let(:work) {Work.create(depositor: usr.email, title:["test title"])}
  let(:parent_work) {Work.create(depositor: usr.email, title:["parent work title"])}
  
  after(:all) do
    Work.all.each{|wrk| wrk.destroy}
  end

  it "can be saved with simple metadata" do
    work.send("#{simple_inheritable_field_name}=",["test value 1","test value 2"])
    work.save
    expect(work.send(simple_inheritable_field_name.to_s).count).to eq(2)
    expect(work.send(simple_inheritable_field_name.to_s).count).to include("test value 1","test value 2")
  end

  it "can be saved with complex metadata" do
    work.send("#{complex_inheritable_field_name}_attributes=",[{id:"http://id.loc.gov/authorities/names/n95057625"}])
    work.save
    expect(work.send(complex_inheritable_field_name.to_s).count).to eq(1)
  end

  it "has all metadata properties defined as methods" do
    expect(work.methods).to include(*schema.fields.keys.map{|key| key.to_sym})
  end

  it "has controlled properties properly defined" do
    expect(work.methods).to include(*schema.controlled_field_names.map{|field_name| "#{field_name}_attributes=".to_sym })
  end

  it "inherits simple, inheritable metadata fields from a parent work" do 
    test_val = "a test value"
    parent_work.send("#{simple_inheritable_field_name}=",[test_val])
    parent_work.ordered_members << work
    parent_work.save
    work.save
    expect(Work.find(work.id).send(simple_inheritable_field_name.to_s)).to include test_val
  end

  it "inherits complex, inheritable metadata fields from a parent work" do 
    test_controlled_url = "http://id.loc.gov/authorities/names/n95057625"
    parent_work.send("#{complex_inheritable_field_name}_attributes=",[{id: test_controlled_url}])
    parent_work.ordered_members << work
    parent_work.save
    work.save
    expect(Work.find(work.id).send(complex_inheritable_field_name.to_s).map(&:id)).to include test_controlled_url
  end

  it "does not inherit non-inheritable metadata fields from a parent work" do 
    test_val = "a test value"
    parent_work.send("#{non_inheritable_field_name}=",[test_val])
    parent_work.ordered_members << work
    parent_work.save
    work.save
    expect(Work.find(work.id).send(simple_inheritable_field_name.to_s)).not_to include test_val
  end

  it "does not inherit populated metadata fields from a parent work" do 
    parent_work.send("#{simple_inheritable_field_name}=",["parent value"])
    parent_work.ordered_members << work
    parent_work.save
    work.send("#{simple_inheritable_field_name}=",["child value"])
    work.save
    expect(Work.find(work.id).send(simple_inheritable_field_name.to_s)).not_to include "parent value"
    
  end

  it "does not inherit metadata if it is explicitly set not to" do 
  end


end
