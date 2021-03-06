require 'rails_helper'

RSpec.describe SolrDocument do

  describe "solr_name class method" do
    it "properly returns solr names based on indexing parameters" do
      expect(described_class.solr_name("title")).to include("title_tesim")
#      expect(described_class.solr_name("keyword")).to include("keyword_ssim")
    end
  end

  describe "instance methods for solr properties" do
    it "are defined" do
      expect(described_class.instance_methods.grep(/physicalDescription/).count).to eq(1)
      expect(described_class.instance_methods.grep(/language/).count).to eq(1)
      expect(described_class.instance_methods.grep(/keyword/).count).to eq(1)
      expect(described_class.instance_methods.grep(/staffNote/).count).to eq(1)
    end
  end

  describe "field_semantics class method" do
    it("returns customized oai feed parameters") do
      expect(described_class.field_semantics.keys).to include("DC:type","DPLA:isShownAt")
      expect(described_class.field_semantics["DC:creator"]).to include("creator")
      expect(described_class.field_semantics["DC:type"]).to include("resourceType")
      expect(described_class.field_semantics.keys).not_to include(/physicalDescription/)
      expect(described_class.field_semantics.values).not_to include(/physicalDescription/)
    end
  end

end
