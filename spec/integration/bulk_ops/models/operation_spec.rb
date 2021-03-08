require 'rails_helper'

RSpec.describe BulkOps::Operation do
  
  describe "A bulk update" do
    let(:usr) {User.create(email:"test user email")}
    let!(:op_name) {BulkOps::Operation.unique_name("rspec test branch", usr)}
    let!(:draft) {described_class.create(name: op_name, user_id: usr.id, stage: "draft", status: "new")}
    let!(:wrk1) {Work.create(depositor: usr.email, title:["test title"])}
    let!(:wrk2) {Work.create(depositor: usr.email, title:["test title"])}
    let!(:proxy1) {draft.work_proxies.create(work_id: wrk1.id,status:"new")}
    let!(:proxy2) {draft.work_proxies.create(work_id: wrk2.id,status:"new")}

    after(:all) do
      Work.all.each{|wrk| wrk.destroy}
    end

    before(:each)  do 
      draft.create_branch
    end
    after(:each) {draft.delete_branch}

    it "is persisted in the database" do
      expect(described_class.find_by(id: draft.id)).to be_present
    end
    
    it "can recognize its contained works" do
      expect(draft.work_proxies.count).to eq(2)
    end

    it "puts a template options file in its new github branch" do
      expect(BulkOps::GithubAccess.load_options(draft.name)).to be_instance_of(Hash)
    end
    
    it "puts a spreadsheet of existing data in its new github branch" do
      sheet = BulkOps::GithubAccess.load_metadata(branch: draft.name)
      expect(sheet).to be_instance_of(CSV::Table)
      expect(sheet.count).to eq(draft.work_proxies.count)
    end

    it "can update the operation status appropriately" do
      draft.stage = "pending"
      draft.status = "ok"
      draft.message = "Update branch created in github"
      draft.save
      expect(described_class.find(draft.id).stage).to eq("pending")
    end

    context "with an updated sheet" do
      let(:tmp_file){Tempfile.new('test-update-sheet')}
      let(:altered_title){"new altered test title"}

      before(:each) do
        sheet = BulkOps::GithubAccess.load_metadata(branch: draft.name)
        sheet.first["title"] = altered_title
        CSV.open(tmp_file, "wb") do |csv|
          csv << sheet.headers
          sheet.each {|row| csv << row.fields}
        end
        draft.update_spreadsheet tmp_file.path
      end

      after(:each){tmp_file.unlink}

      it "succesfully updates the spreadsheet in Github" do
        updated_sheet = BulkOps::GithubAccess.load_metadata(branch: draft.name)
        expect(updated_sheet.first["title"]).to eq(altered_title)
      end
    end

    context "with updated options" do
      let(:altered_status){"new altered status"}

      before(:each) do
        options = BulkOps::GithubAccess.load_options(draft.name)
        options["status"] = altered_status
        draft.update_options options
      end

      it "succesfully updates the config file in Github" do
        updated_options = BulkOps::GithubAccess.load_options(draft.name)
        expect(updated_options["status"]).to eq(altered_status)
      end
    end

  end
end
