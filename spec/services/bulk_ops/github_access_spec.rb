require 'rails_helper'

RSpec.describe BulkOps::GithubAccess do
  let!(:usr) { create(:user) }
  let!(:git) {described_class.new("rspec test branch")}

  before(:each) do
    git.create_branch!
  end

  after(:each) do
    git.delete_branch!
  end

  describe "branch management" do
    let!(:branches) {git.list_branches}
    let!(:branch_names) {git.list_branch_names}


    it "can return a list of branches in the repo" do
      expect(branches).to be_instance_of(Array)
      expect(branch_names).to be_instance_of(Array)
    end

    it "does not include the master branch in the branch list" do
      expect(branch_names).not_to include("master")
    end

    it "finds our newly created branch" do
      expect(branch_names).to include(git.name)
    end

    it "can delete this new branch" do
      git.delete_branch!
      sleep(0.5)
      expect(git.list_branch_names).not_to include(git.name)
    end

  end

  describe "file management" do

    context "with a new file added from the filesystem" do 
      it "can retrieve and verify the file's contents" do

      end
    end


    context "With new file by its contents" do
      it "can retrieve and verify the file's contents" do

      end
    end

    context "With an update to the " do
      it "can retrieve and verify the file's contents" do

      end
    end

    it "can auto-update the 'options' file for this bulk operation" do

    end

    it "can update the spreadsheet for this bulk operation" do

    end

    


  end

end
