require 'rails_helper'

RSpec.describe BulkOps::Parser do
  
  describe "A parser" do
    let(:usr) { create(:admin) }
    let(:op_name) {BulkOps::Operation.unique_name("rspec test branch", usr)}
    let!(:operation) {BulkOps::Operation.create(name: op_name, user_id: usr.id, operation_type: "ingest", status: "new", stage: "new")}
    let(:wrk) {Work.create(depositor: usr.email, title:["test title"])}
#    let(:wrk2) {Work.create(depositor: usr.email, title:["Another test title"])}
    let(:template_data) {[{"Title" => "Parent Work", "description " => "This is a test description of a test parent item"},
                          {"Title" => "First Child Work", "description " => "This is a test description of a test child item", "parent" => "id:#{wrk.id}"},
                          {"Title" => "Second Child Work", "description " => "This is a test description of a test child item", "parent" => "row:2"},
                          {"Title" => "Third Child Work", "description " => "This is a test description of a test child item", "parent" => "row:-3"},
                          {"Title" => "Last Child Work", "description " => "This is a test description of a test child item", "parent" => "row:prev"}]}
    let(:parent_proxy) {operation.work_proxies.create( work_id: wrk.id, status:"new", row_number: 0)}
    let(:first_child_proxy) {operation.work_proxies.create(status:"new", row_number: 1)}
    let(:second_child_proxy) {operation.work_proxies.create(status:"new", row_number: 2)}
    let(:third_child_proxy) {operation.work_proxies.create(status:"new", row_number: 3)}
    let(:last_child_proxy) {operation.work_proxies.create(status:"new", row_number: 4)}
    let(:parent_parser) {described_class.new(parent_proxy, template_data)}
    let(:first_child_parser) {described_class.new(first_child_proxy, template_data)}
    let(:second_child_parser) {described_class.new(second_child_proxy, template_data)}
    let(:third_child_parser) {described_class.new(third_child_proxy, template_data)}
    let(:last_child_parser) {described_class.new(last_child_proxy, template_data)}
    let(:parser) {parent_parser}
    let(:sample_url) {"http://id.loc.gov/authorities/names/no90012358"}
    let(:sample_filenames) {["cat.jpg","Domestic_Cat.jpg","cat-cute-cute-pets.jpg"]}

    before(:all) do
      @coltype = Hyrax::CollectionType.find_or_create_default_collection_type
    end

    after(:all) do
      Work.all.each{|wrk| wrk.destroy}
      BulkOps::WorkProxy.all.each{|proxy| proxy.destroy}
      BulkOps::Relationship.all.each{|rel| rel.destroy}
    end

    before(:each) do
      operation.create_branch
    end

    after(:each) do
      operation.delete_branch
    end
    
    #      it "can place a hold on a work, preventing browser edits" do
    #        #TODO
    #      end
    #
    #      it "can remove a hold from a work, allowing browser edits" do
    #        #TODO
    #      end
    #


    it "can interpret basic scalar data" do
      sample_data = template_data.dup.first
      metadata = parent_parser.interpret_data(proxy: parent_proxy)
      expect(metadata).to be_a(Hash)
      expect(metadata["title"]).to include(sample_data["Title"])
      expect(metadata["description"]).to include(sample_data["description "])
    end

    it "can interpret scalar sample_data with multiple columns per parameter and multiple values per cell" do
      sample_data = template_data.dup.first
      sample_data["description"] = "another description;Yet another description"
      metadata = parser.interpret_data(raw_row: sample_data)
      expect(metadata).to be_a(Hash)
      expect(metadata.count).to be > 2
      expect(metadata["description"].count).to eq(3)
    end

    it "can interpret controlled vocab url" do
      sample_data = template_data.dup.first
      sample_data["Creator"] = sample_url
      metadata = parser.interpret_data(raw_row: sample_data)
      expect(metadata["creator_attributes"][0]["id"]).to eq(sample_url) 
    end

    it "can interpret controlled vocab url field with specified authority" do
      sample_data = template_data.dup.first
      sample_data["Creator.loc"] = sample_url
      metadata = parser.interpret_data(raw_row: sample_data)
      expect(metadata["creator_attributes"][0]["id"]).to eq(sample_url) 
    end

    it "can interpret a label in a controlled vocab field" do
      sample_data = template_data.dup.first
      sample_data["Creator"] = "Bob the drag queen"
      metadata = parser.interpret_data(raw_row: sample_data)
      url = metadata['creator_attributes'][0]["id"]
      id = url.split(File::SEPARATOR).last
      local_entry = Qa::LocalAuthorityEntry.find_by(uri:id)
      label = local_entry.label || false
      expect(label).to eq(sample_data["Creator"]) 
      metadata2 = parser.interpret_data(raw_row: sample_data)
      expect(metadata2['creator_attributes'][0]["id"]).to eq(url)
    end

    it "can interpret new file fields" do
      sample_data = template_data.dup.first
      sample_data["filename"] = "cats/#{sample_filenames[0]}"
      sample_data["File"] = "cats/#{sample_filenames[1]}"
      sample_data["Files To Add"] = "cats/#{sample_filenames[2]}"
      metadata = parser.interpret_data(raw_row: sample_data)
      (metadata[:uploaded_files] || []).each do |up_file_id|
        uf = Hyrax::UploadedFile.find(up_file_id)
        expect(sample_filenames).to include(uf.file_url.split(File::SEPARATOR).last)
      end
    end

#    it "can interpret fields that remove files" do
#      sample_data = template_data.dup.first
#      sample_data["filenames to remove"] = "cats/#{sample_filenames[0]}"
#      sample_data["Files_to_delete"] = "cats/#{sample_filenames[1]}"
#      sample_data["remove file"] = "cats/#{sample_filenames[2]}"
#      metadata = parser.interpret_data(sample_data)
#      # Have to create a real fileset to delete. Do that soon.
#    end

    it "can interpret line-specific ingest options" do
      sample_data = template_data.dup.first
      sample_data["Visibility"] = "public"
      sample_data["Work Type"] = " Lecture  "
      parent_proxy.visibility = "private"
      parent_proxy.work_type = "Work"
      metadata = parser.interpret_data(raw_row: sample_data)
      parent_proxy.reload
      expect(parent_proxy.visibility).to eq("open")
      expect(parent_proxy.work_type).to eq("Lecture")
    end

    it "can interpret fields that indicate membership in an existing collection" do
      sample_collection_names = ["Test Collection","Other Test Collection"]
      collection_ids = sample_collection_names.map{ |name| Collection.create(title: [name], depositor: usr.email, collection_type: @coltype ).id}
      sample_data = template_data.dup.first
      sample_data["Collection"] = sample_collection_names.first 
      sample_data["collection_title"] = sample_collection_names.last
      metadata = parser.interpret_data(raw_row: sample_data)
      #Expect the work to become part of the existing collection immediately
      collection_ids.each do |id|
        expect(metadata[:member_of_collection_ids]).to include(id)
      end
    end

    it "can interpret fields that indicate membership in a new collection" do
      sample_collection_names = ["Test Collection New","Other Test Collection New"]
      sample_data = template_data.dup.first
      sample_data["Collection"] = sample_collection_names.first 
      sample_data["collection_title"] = sample_collection_names.last
      metadata = parser.interpret_data(raw_row: sample_data)
      #Expect the work to become part of the existing collection immediately
      sample_collection_names.each do |name|
        collection = Collection.where(title: name).last
        expect(metadata[:member_of_collection_ids]).to include(collection.id)
      end
    end

    it "can interpret parent relationships based on existing work id" do
      first_child_parser.interpret_data
      rel = BulkOps::Relationship.find_by(work_proxy_id: first_child_proxy.id, identifier_type: "id", object_identifier: wrk.id)
      expect(rel).not_to be_nil
      expect(rel.relationship_type).to eq("parent")
    end

    it "can interpret parent/child relationships based on absolute row number" do
      second_child_parser.interpret_data
      rel = BulkOps::Relationship.find_by(work_proxy_id: second_child_proxy.id, identifier_type: "row", object_identifier: 0)
      expect(rel).not_to be_nil
      expect(rel.relationship_type).to eq("parent")
    end

    it "can interpret parent/child relationships based on relative row number" do
      third_child_parser.interpret_data
      rel = BulkOps::Relationship.find_by(work_proxy_id: third_child_proxy.id, identifier_type: "row", object_identifier: 0)
      expect(rel).not_to be_nil
      expect(rel.relationship_type).to eq("parent")
    end

    it "can interpret parent/child relationships based on the previous non-child row" do
      last_child_parser.interpret_data
      rel = BulkOps::Relationship.find_by(work_proxy_id: last_child_proxy.id, identifier_type: "row", object_identifier: 0)
      expect(rel).not_to be_nil
      expect(rel.relationship_type).to eq("parent")
    end

#    it "can interpret order related relationships" do
#      sample_data = template_data.dup
#      sample_data["order"] = "2.2"
#      sample_data["next"] = wrk2.id
#      metadata = parser.interpret_data(sample_data)
#      expect(proxy.order.to_f).to eq(2.2)
#      expect(BulkOps::Relationship.find_by(work_proxy_id: proxy.id, object_identifier: wrk2.id).relationship_type).to eq("next")
#
#    end
#
    
  end

end
