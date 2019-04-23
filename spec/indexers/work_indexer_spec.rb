require 'rails_helper'

RSpec.describe WorkIndexer do

  describe "The work indexer class" do

    it "can find the label for LOC urls" do
      expect(described_class.fetch_remote_label("http://id.loc.gov/authorities/subjects/sh85021262")).to eq("Cats")
      expect(described_class.fetch_remote_label("http://id.loc.gov/vocabulary/iso639-2/eng")).to eq("English")
    end

    it "can find the label for a Geonames url" do
      expect(described_class.fetch_remote_label("http://www.geonames.org/5404900")).to eq("University of California Santa Cruz")
    end

    it "can find the label for a Getty url" do
      expect(described_class.fetch_remote_label("http://vocab.getty.edu/aat/300128343")).to eq("black-and-white negatives")
    end

    it "can find the label for a purl url" do
      expect(described_class.fetch_remote_label("http://purl.org/dc/dcmitype/Image")).to eq("Image")
    end

    it "can find the label for a local url" do
      auth = Qa::LocalAuthority.find_or_create_by(name: "agents")
      entry = Qa::LocalAuthorityEntry.create(local_authority: auth,
                                             label: "Cataract",
                                             uri: "cataract")
      expect(described_class.fetch_remote_label("https://digitalcollections.library.ucsc.edu/authorities/show/local/agents/cataract")).to eq("Cataract")
    end

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
      LdBuffer.create(url: url, label: "Sample Label")
      expect(described_class.fetch_remote_label(url)).to eq("Sample Label")
    end    

  end
  
  describe "An indexer for a work" do

    let(:work_properties){{title: ["untitled"],
                           depositor: usr.email,
                           subseries: ["Men walking dogs in parks"],
                           series: ["Canine Insanity"],
                           subjectTopic_attributes: [{id: "info:lc/authorities/subjects/sh85028356"}],
                           subjectName_attributes: [{id: "info:lc/authorities/names/n79059545"}],
                           collectionCallNumber: ["1"], 
                           itemCallNumber: ["2"] }}
    let(:usr) {User.create(email:"test user email")}
    let!(:wrk){Work.create(work_properties)}
    let(:indexer){described_class.new(wrk)}

    it "combines the subject fields" do
      expect(wrk.to_solr["subject_tesim"].count).to eq(2)
    end

    it "combines the call number fields" do
      expect(wrk.to_solr["callNumber_tesim"]).to include("1","2")
    end

    it "combines the title fields" do
      title = wrk.to_solr["titleDisplay"].first
      expect(title).to start_with("Men walking dogs in parks")
      expect(title).to end_with("Canine Insanity")
    end
    
  end
  
end
