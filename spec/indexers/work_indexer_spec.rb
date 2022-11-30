require 'rails_helper'

RSpec.describe WorkIndexer do

  describe "The work indexer class" do

    # it "can find the label for LOC urls" do
    #   expect(described_class.fetch_remote_label("http://id.loc.gov/authorities/subjects/sh85021262").to_s).to eq("Cats")
    #   expect(described_class.fetch_remote_label("http://id.loc.gov/vocabulary/iso639-2/eng")).to eq("English")
    #   expect(described_class.fetch_remote_label("info:lc/authorities/names/n79059545")).to eq("University of California, Santa Cruz")
    # end

    it "can find the label for a Geonames url" do
      expect(described_class.fetch_remote_label("http://www.geonames.org/5404900")).to eq("University of California Santa Cruz")
    end

    # it "can find the label for a Getty url" do
    #   expect(described_class.fetch_remote_label("http://vocab.getty.edu/aat/300128343")).to eq("black-and-white negatives")
    # end

    # These URLS are legit failing 404 for some reason, even though they are officially supported linked data URLs.
    # Maybe we need to make a local copy to get them to index properly?
#    it "can find the label for a purl url" do
#      expect(described_class.fetch_remote_label("http://purl.org/dc/dcmitype/Image")).to eq("Image")
#    end

#    it "can find the label for a local url" do
#      auth = Qa::LocalAuthority.find_or_create_by(name: "agents")
#      unless Qa::LocalAuthorityEntry.any?{|entry| entry.uri == "cataract" && entry.local_authority_id == auth.id}
#        entry = Qa::LocalAuthorityEntry.create(local_authority: auth,
#                                               label: "Cataract",
#                                               uri: "cataract")
#        sleep(5)
#      end
#      expect(described_class.fetch_remote_label("http://localhost:3000/authorities/show/local/agents/cataract")).to eq("Cataract")
#    end

    it "buffers retrieved labels" do
      url = "http://www.geonames.org/5404900"
      if (buffer = LdBuffer.find_by(url: url))
        buffer.destroy
      end
      described_class.fetch_remote_label(url)
      expect(LdBuffer.find_by(url: url)).not_to be_nil
      expect(LdBuffer.find_by(url: url).label).to eq("University of California Santa Cruz")
    end

    it "retrieves buffered labels" do
      url = "httq://NOTAREALURL/THISISFAKE"
      buff = LdBuffer.create(url: url, label: "Sample Label")
      expect(described_class.fetch_remote_label(url)).to eq("Sample Label")
      buff.destroy
    end    

  end
  
  describe "An indexer for a work" do

    after(:all) do
#      Work.all.each{|wrk| wrk.destroy}
    end

    let(:work_properties){{title: ["untitled"],
                           depositor: usr.email,
                           subseries: ["Men walking dogs in parks"],
                           series: ["Canine Insanity"],
                           subjectTopic_attributes: [{id: "info:lc/authorities/subjects/sh85028356"}],
                           subjectName_attributes: [{id: "info:lc/authorities/names/n79059545"}],
                           collectionCallNumber: ["1"], 
                           itemCallNumber: ["2"] }}
    let(:usr) {User.find_by_email('test-email') || User.create(email:"test-email@test.test", password: "testpassword")}
    let!(:wrk){Work.create(work_properties)}
    let(:indexer){described_class.new(wrk)}

    # it "combines the subject fields" do
    #   expect(wrk.to_solr["subject_tesim"].count).to eq(2)
    # end

    it "combines the call number fields" do
      expect(wrk.to_solr["callNumber_tesim"]).to include("1","2")
    end

#    it "combines the title fields" do
#      title = wrk.to_solr["titleDisplay_tesim"].first
#      expect(title).to start_with("Men walking dogs in parks")
#      expect(title).to end_with("Canine Insanity")
#    end

#   We currently have no plans to have metadata inherited in Solr but not in Fedora,
#   so the metadata inheritance features of the work indexer are not in use and are not tested.
#    it "inherits metadata when appropriate" do
#
#    end
#    
#    it "does not inherit metadata from the wrong fields" do
#
#    end
#    
#    it "does not overwrite existing metadata with inherited metadata" do
#
#    end
#    
  end
  
end
