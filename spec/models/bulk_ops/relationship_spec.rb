require 'rails_helper'

RSpec.describe BulkOps::Relationship do
  
  describe "A relationship" do
    let(:usr) {User.create(email:"test user email")}
    let(:wrk) {Work.create(depositor: usr.email, title:["test title"])}
    let(:wrk2) {Work.create(depositor: usr.email, title:["Another test title"])}
    let(:wrk3) {Work.create(depositor: usr.email, title:["A third test title"])}
    let(:wrk4) {Work.create(depositor: usr.email, title:["A fourth test title"])}
    let(:op_name) {BulkOps::Operation.unique_name("rspec test branch", usr)}
    let!(:operation) {BulkOps::Operation.create(name: op_name, user_id: usr.id, operation_type: "ingest", status: "new", stage: "new")}
    let(:proxy) {BulkOps::WorkProxy.create(operation_id: operation.id, work_id: wrk.id, work_type: "Work", status:"new")}
    let(:relationship){described_class.create( { work_proxy_id: proxy.id,
                                                 identifier_type: "id",
                                                 relationship_type: "parent",
                                                 object_identifier: wrk2.id,
                                                 status: "new"})}

    it "can find an object work by id" do
      relationship.identifier_type = "id"
      relationship.save
      expect(relationship.findObject).to be_truthy
    end

    it "can implement a parent relationship between existing works" do
      relationship.relationship_type = "parent"
      relationship.object_identifier = wrk2.id
      relationship.save
      sleep(1)
      relationship.resolve!
      expect(SolrDocument.find(wrk.id).parent_work.id).to eq(wrk2.id)
    end

    it "can implement a child relationship between existing works" do
      relationship.relationship_type = "child"
      relationship.object_identifier = wrk3.id
      relationship.save
      sleep(1)
      relationship.resolve!
      expect(SolrDocument.find(wrk3.id).parent_work.id).to eq(wrk.id)
    end

    #    it "can implement a 'next' relationship between existing records" do 
    #    end
    #
    #    it "can implement an 'order' relationship between existing files" do 
    #    end

    it "waits if the object work does not exist" do
      wrk2.destroy
      relationship.status = "new"
      relationship.object_identifier = wrk2.id
      relationship.save
      relationship.resolve!
      expect(relationship.status).to eq("pending")
    end



    it "waits if the subject work does not exist" do
      wrk.destroy
      relationship.status = "new"
      relationship.object_identifier = wrk3.id
      relationship.save
      relationship.resolve!
      expect(relationship.status).to eq("pending")      
    end



  end
end
