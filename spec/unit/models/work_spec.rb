require 'rails_helper'

RSpec.describe Work do
  let(:usr) {User.find_by_email('test@example.com') || User.create(email:"test@example.com", password: "password")}
  let(:schema) {ScoobySnacks::METADATA_SCHEMA}
  let(:simple_inheritable_field_name) {(schema.inheritable_field_names - schema.controlled_field_names).first}
  let(:complex_inheritable_field_name) {(schema.inheritable_field_names & schema.controlled_field_names).first}
  let(:non_inheritable_field_name) {(schema.all_field_names - schema.controlled_field_names - schema.inheritable_field_names).first}
  let(:simple_collection_inheritable_field_name) {(schema.collection_inheritable_field_names - schema.controlled_field_names).first}
  let(:complex_collection_inheritable_field_name) {(schema.collection_inheritable_field_names & schema.controlled_field_names).first}
  let(:non_collection_inheritable_field_name) {(schema.all_field_names - schema.controlled_field_names - schema.collection_inheritable_field_names).first}
  let(:work) {Work.create(depositor: usr.email, title:["test title"])}
  let(:parent_work) {Work.create(depositor: usr.email, title:["parent work title"])}
  let(:parent_collection) {Collection.create(depositor: usr.email, title:["parent collection"], collection_type: Hyrax::CollectionType.find_or_create_default_collection_type)}
  
  it "can be saved with simple metadata" do
    work.send("#{simple_inheritable_field_name}=",["test value 1","test value 2"])
    work.save
    expect(work.send(simple_inheritable_field_name.to_s).count).to eq(2)
    expect(work.send(simple_inheritable_field_name.to_s)).to include("test value 1","test value 2")
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

  it "displays the subseries in the title if it is untitled" do
    work.title = ["untitled"]
    work.subseries = ["subseries"]
    work.save
    expect(work.title.first.downcase).to include("untitled")
    expect(work.title.first).to include("subseries")
    expect(work.title.to_s).to include("subseries")
    
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

    it "inherits simple, collection-inheritable metadata fields from a parent collection" do 
    test_val = "a test value"
    parent_collection.send("#{simple_collection_inheritable_field_name}=",[test_val])
    parent_collection.save
    work.member_of_collections << parent_collection
    work.save
    expect(Work.find(work.id).send(simple_collection_inheritable_field_name.to_s)).to include test_val
  end
  
  it "inherits complex, collection-inheritable metadata fields from a parent collection" do 
    test_controlled_url = "http://id.loc.gov/authorities/names/n95057625"
    parent_collection.send("#{complex_collection_inheritable_field_name}_attributes=",[{id: test_controlled_url}])
    parent_collection.save
    work.member_of_collections << parent_collection
    work.save
    expect(Work.find(work.id).send(complex_collection_inheritable_field_name.to_s).map(&:id)).to include test_controlled_url
  end

  it "does not inherit non-collection-inheritable metadata fields from a parent collection" do 
    test_val = "a test value"
    parent_work.send("#{non_collection_inheritable_field_name}=",[test_val])
    parent_collection.save
    work.member_of_collections << parent_collection
    work.save
    expect(Work.find(work.id).send(simple_collection_inheritable_field_name.to_s)).not_to include test_val
  end

  it "does not inherit populated metadata fields from a parent collection" do 
    parent_work.send("#{simple_collection_inheritable_field_name}=",["parent value"])
    parent_work.ordered_members << work
    parent_work.save
    work.save
    expect(Work.find(work.id).send(simple_collection_inheritable_field_name.to_s)).not_to include "parent value"
  end

#  it "can process hyphen-separated year month dates" do
#    work.dateCreated = ["11-1967"]
#    work.save
#    expect(work.dateCreated).to include("11/1967")
#  end

  it "knows how to fix an improperly formatted Getty url" do
    work.subjectTopic_attributes = [{id: "http://vocab.getty.edu/page/aat/300001581"}]
    work.save
    expect(SolrDocument.find(work.id).subjectTopic).to include("annulated columns")
  end

  it "knows how to fix an improperly formatted LOC url" do
    expect(work.fix_loc_id("info:lc/authorities/sh92005191")).to eq("http://id.loc.gov/authorities/sh92005191")
  end

  it "correctly serializes multiple titles" do
    expect(work.to_s).to eq(work.title.first)
    work.title = ["first title","second title"]
    work.save
    expect(work.to_s).to include("first title")
    expect(work.to_s).to include("|")
    expect(work.to_s).to include("second title")
  end

  it "can link to its associated solr document" do
    expect(work.solr_document).to be_a(SolrDocument)
  end
  
end
