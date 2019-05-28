require 'rails_helper'

RSpec.describe BulkOps::WorkProxy do
  
  describe "A work proxy" do
    let(:usr) { create(:admin) }
    let(:op_name) {BulkOps::Operation.unique_name("rspec test branch", usr)}
    let!(:operation) {BulkOps::Operation.create(name: op_name, user_id: usr.id, operation_type: "ingest", status: "new", stage: "new")}
    let(:template_data){ {"Title" => "Test Title", "description ": "This is a test description of a test item"} }
    let(:wrk) {Work.create(depositor: usr.email, title:["test title"])}
    let(:wrk2) {Work.create(depositor: usr.email, title:["Another test title"])}
    let(:wrk3) {Work.create(depositor: usr.email, title:["A third test title"])}
    let(:wrk4) {Work.create(depositor: usr.email, title:["A fourth test title"])}
    let(:proxy) {described_class.create(operation_id: operation.id, work_id: wrk.id, status:"new")}
    let(:sample_url) {"http://id.loc.gov/authorities/names/no90012358"}
    let(:sample_filenames) {["cat.jpg","Domestic_Cat.jpg","cat-cute-cute-pets.jpg"]}

    before(:all) do
      @coltype = Hyrax::CollectionType.first or Hyrax::CollectionType.create(title: "User Collection", description: "A User Collection can be created by any user to or...", machine_id: "user_collection", nestable: true, discoverable: true, sharable: true, allow_multiple_membership: true, require_membership: false, assigns_workflow: false, assigns_visibility: false, share_applies_to_new_works: false, brandable: true, badge_color: "#705070")
    end

    after(:all) do
      Work.all.each{|wrk| wrk.destroy}
      @coltype.destroy
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
      sample_data = template_data
      metadata = proxy.interpret_data(sample_data)
      expect(metadata).to be_a(Hash)
      expect(metadata.count).to be > sample_data.count
    end

    it "can interpret scalar sample_data with multiple columns per parameter and multiple values per cell" do
      sample_data = template_data.dup
      sample_data["description"] = "another description;Yet another description"
      metadata = proxy.interpret_data(sample_data)
      expect(metadata).to be_a(Hash)
      expect(metadata.count).to be > 2
      expect(metadata["description"].count).to eq(3)
    end

    it "can interpret controlled vocab url" do
      sample_data = template_data.dup
      sample_data["Creator"] = sample_url
      metadata = proxy.interpret_data(sample_data)
      expect(metadata["creator_attributes"][0]["id"]).to eq(sample_url) 
    end

    it "can interpret controlled vocab url field with specified authority" do
      sample_data = template_data.dup
      sample_data["Creator.loc"] = sample_url
      metadata = proxy.interpret_data(sample_data)
      expect(metadata["creator_attributes"][0]["id"]).to eq(sample_url) 
    end

    it "can interpret label in controlled vocab field" do
      sample_data = template_data.dup
      sample_data["Creator"] = "Bob the drag queen"
      metadata = proxy.interpret_data(sample_data)
      url = metadata['creator_attributes'][0]["id"]
      id = url.split(File::SEPARATOR).last
      local_entry = Qa::LocalAuthorityEntry.find_by(uri:id)
      label = local_entry.label || false
      expect(label).to eq(sample_data["Creator"]) 
      metadata2 = proxy.interpret_data(sample_data)
      expect(metadata2['creator_attributes'][0]["id"]).to eq(url)
    end

    it "can interpret new file fields" do
      sample_data = template_data.dup
      sample_data["filename"] = "cats/#{sample_filenames[0]}"
      sample_data["File"] = "cats/#{sample_filenames[1]}"
      sample_data["Files To Add"] = "cats/#{sample_filenames[2]}"
      metadata = proxy.interpret_data(sample_data)
      (metadata[:uploaded_files] || []).each do |up_file_id|
        uf = Hyrax::UploadedFile.find(up_file_id)
        expect(sample_filenames).to include(uf.file_url.split(File::SEPARATOR).last)
      end
    end

#    it "can interpret fields that remove files" do
#      sample_data = template_data.dup
#      sample_data["filenames to remove"] = "cats/#{sample_filenames[0]}"
#      sample_data["Files_to_delete"] = "cats/#{sample_filenames[1]}"
#      sample_data["remove file"] = "cats/#{sample_filenames[2]}"
#      metadata = proxy.interpret_data(sample_data)
#      # Have to create a real fileset to delete. Do that soon.
#    end

    it "can interpret line-specific ingest options" do
      sample_data = template_data.dup
      sample_data["Visibility"] = "public"
      sample_data["Work Type"] = " Lecture  "
      proxy.visibility = "private"
      proxy.work_type = "Work"
      metadata = proxy.interpret_data(sample_data)
      proxy.reload
      expect(proxy.visibility).to eq("open")
      expect(proxy.work_type).to eq("Lecture")
    end

    it "can interpret fields that indicate membership in an existing collection" do
      sample_collection_names = ["Test Collection","Other Test Collection"]
      collection_ids = sample_collection_names.map{ |name| Collection.create(title: [name], depositor: usr.email, collection_type: @coltype ).id}
      sample_data = template_data.dup
      sample_data["Collection"] = sample_collection_names.first 
      sample_data["collection_title"] = sample_collection_names.last
      metadata = proxy.interpret_data(sample_data)
      #Expect the work to become part of the existing collection immediately
      collection_ids.each do |id|
        expect(metadata[:member_of_collection_ids]).to include(id)
      end
    end

    it "can interpret fields that indicate membership in a new collection" do
      sample_collection_names = ["Test Collection New","Other Test Collection New"]
      sample_data = template_data.dup
      sample_data["Collection"] = sample_collection_names.first 
      sample_data["collection_title"] = sample_collection_names.last
      metadata = proxy.interpret_data(sample_data)
      #Expect the work to become part of the existing collection immediately
      sample_collection_names.each do |name|
        collection = Collection.where(title: name ).last
        expect(metadata[:member_of_collection_ids]).to include(collection.id)
      end
    end

    it "can interpret parent/child relationships" do
      sample_data = template_data.dup
      sample_data["Parent"] = wrk2.id
      sample_data["id:Child"] = wrk3.id
      sample_data["Child"] = "id:#{wrk4.id}"
      metadata = proxy.interpret_data(sample_data)
      expect(BulkOps::Relationship.find_by(work_proxy_id: proxy.id, object_identifier: wrk2.id).relationship_type).to eq("parent")
      expect(BulkOps::Relationship.find_by(work_proxy_id: proxy.id, object_identifier: wrk3.id).relationship_type).to eq("child")
    end

    it "can interpret order related relationships" do
      sample_data = template_data.dup
      sample_data["order"] = "2.2"
      sample_data["next"] = wrk2.id
      metadata = proxy.interpret_data(sample_data)
      expect(proxy.order.to_f).to eq(2.2)
      expect(BulkOps::Relationship.find_by(work_proxy_id: proxy.id, object_identifier: wrk2.id).relationship_type).to eq("next")

    end

    
  end

end
