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

  context "when accepting controlled metadata" do

    def test_fetch_label(url) 
      @wrk.creator_attributes= [{id: url}]
      @wrk.save
      creator = @wrk.creator.first
      expect !creator.nil?
      creator.fetch
      expect !creator.rdf_label.blank?
      expect creator.rdf_label != creator.id 
    end

    it "can fetch LOC names from URLs" do
      test_fetch_label("http://id.loc.gov/authorities/names/n80095119")
    end

    it "can fetch LOC subjects from URLs" do
      test_fetch_label("http://id.loc.gov/authorities/subjects/sh85133890")
    end

    it "can fetch LOC subjects from old crappy URLs" do
      test_fetch_label("info:lc/authorities/sh85133890")
    end

    it "can fetch LOC MARC languages" do
      test_fetch_label("http://id.loc.gov/vocabulary/languages/eng")
    end

    it "can fetch Getty ULAN from URLs" do
      test_fetch_label("http://vocab.getty.edu/ulan/500112651")
    end

    it "can fetch Getty AAT from URLs" do
      test_fetch_label("http://vocab.getty.edu/aat/300001667")
    end

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
