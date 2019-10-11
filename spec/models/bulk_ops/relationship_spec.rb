require 'rails_helper'

RSpec.describe BulkOps::Relationship do
  
  describe "A relationship" do
    let(:usr) {User.find_by_email('test-email') || User.create(email:"test-email")}
    let(:parent_work) {Work.create(depositor: usr.email, title:["parent title"])}
    let(:first_child_work) {Work.create(depositor: usr.email, title:["first child work title"])}
    let(:last_child_work) {Work.create(depositor: usr.email, title:["last child work title"])}
    let(:inserted_child_work) {Work.create(depositor: usr.email, title:["Inserted child work title"])}

    let(:first_child_proxy) {BulkOps::WorkProxy.create(operation_id: operation.id, work_id: first_child_work.id, work_type: "Work", status:"new")}#
    let(:last_child_proxy) {BulkOps::WorkProxy.create(operation_id: operation.id, work_id: last_child_work.id, work_type: "Work", status:"new")}#
    let(:inserted_child_proxy) {BulkOps::WorkProxy.create(operation_id: operation.id, work_id: inserted_child_work.id, work_type: "Work", status:"new")}

    let(:op_name) {BulkOps::Operation.unique_name("rspec test branch", usr)}
    let!(:operation) {BulkOps::Operation.create(name: op_name, user_id: usr.id, operation_type: "ingest", status: "new", stage: "new")}

    let(:relationship){described_class.create( { work_proxy_id: first_child_proxy.id,
                                                 identifier_type: "id",
                                                 relationship_type: "parent",
                                                 object_identifier: parent_work.id,
                                                 status: "new"})}

    after(:all) do
      Work.all.each{|wrk| wrk.destroy}
    end

    it "can find an object work by id" do
      relationship.identifier_type = "id"
      relationship.save
      expect(relationship.findObject).to be_truthy
    end

    it "can implement a parent relationship between existing works" do
      relationship.relationship_type = "parent"
      relationship.object_identifier = parent_work.id
      relationship.save
      sleep(1)
      relationship.resolve!
      expect(SolrDocument.find(first_child_work.id).parent_work.id).to eq(parent_work.id)
    end

    it "can correctly place a child work in front of existing siblings" do
      relationship.update(work_proxy_id: inserted_child_proxy.id)
      parent_work.ordered_members = [first_child_work]
      parent_work.save
      sleep(1)
      relationship.resolve!
      expect(SolrDocument.find(parent_work.id).member_ids).to eq([first_child_work.id,inserted_child_work.id])
    end

    it "can correctly order a child work between existing siblings" do
      relationship
      inserted_relationship = described_class.create(work_proxy_id: inserted_child_proxy.id,
                                                     identifier_type: "id",
                                                     relationship_type: "parent",
                                                     object_identifier: parent_work.id,
                                                     status: "new",
                                                     previous_sibling: first_child_proxy.id)

      parent_work.ordered_members = [first_child_work,last_child_work]
      parent_work.save
      sleep(1)
      inserted_relationship.resolve!
      expect(SolrDocument.find(parent_work.id).member_ids).to eq([last_child_work.id,first_child_work.id,inserted_child_work.id])
    end


    it "can correctly order a child work first if the preceding work does not exist yet" do
      relationship
      inserted_relationship = described_class.create(work_proxy_id: inserted_child_proxy.id,
                             identifier_type: "id",
                             relationship_type: "parent",
                             object_identifier: parent_work.id,
                             status: "new",
                             previous_sibling: first_child_proxy.id)

      parent_work.ordered_members = [last_child_work]
      parent_work.save
      sleep(1)
      inserted_relationship.resolve!
      expect(SolrDocument.find(parent_work.id).member_ids).to eq([last_child_work.id,inserted_child_work.id])
    end

    it "can correctly order a child work between siblings which do not all exist yet" do

      middle_child_proxy = BulkOps::WorkProxy.create(operation_id: operation.id, work_id: nil, work_type: "Work", status:"new")
      relationship
      described_class.create(work_proxy_id: middle_child_proxy.id,
                             identifier_type: "id",
                             relationship_type: "parent",
                             object_identifier: parent_work.id,
                             status: "new",
                             previous_sibling: first_child_proxy.id)    
      inserted_relationship = described_class.create(work_proxy_id: inserted_child_proxy.id,
                                                     identifier_type: "id",
                                                     relationship_type: "parent",
                                                     object_identifier: parent_work.id,
                                                     status: "new",
                                                     previous_sibling: middle_child_proxy.id)
      
      parent_work.ordered_members = [first_child_work,last_child_work]
      parent_work.save
      sleep(1)
      inserted_relationship.resolve!
      expect(SolrDocument.find(parent_work.id).member_ids).to eq([first_child_work.id,inserted_child_work.id,last_child_work.id])
    end

    it "can implement a child relationship between existing works" do
      relationship.relationship_type = "child"
      relationship.object_identifier = last_child_work.id
      relationship.save
      sleep(1)
      relationship.resolve!
      expect(SolrDocument.find(last_child_work.id).parent_work.id).to eq(first_child_work.id)
    end

    it "waits if the object work does not exist" do
      parent_work.destroy
      relationship.status = "new"
      relationship.object_identifier = parent_work.id
      relationship.save
      relationship.resolve!
      expect(relationship.status).to eq("pending")
    end

    it "waits if the subject work does not exist" do
      first_child_work.destroy
      relationship.status = "new"
      relationship.object_identifier = last_child_work.id
      relationship.save
      relationship.resolve!
      expect(relationship.status).to eq("pending")      
    end

  end
end
