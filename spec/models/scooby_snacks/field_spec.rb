require 'rails_helper'
RSpec.describe ScoobySnacks::Field do
  describe "A sample field" do      
    let(:sample_config_file) {file_fixture("sample_metadata_schema.yml").to_s}
    let(:default_attributes) {YAML.load_file(sample_config_file)['fields']['default']}

    context "with default metadata" do 
      let(:field) {described_class.new("testName",default_attributes.deep_merge({"label" => "Test Label"}))}
      
      it "parses basic information correctly" do 
        expect(field.name).to eq("testName")
        expect(field.label).to eq("Test Label")
      end

      it "has a solr name consistent with being stored but not searchable or faceted" do 
        expect(field.solr_name).to match(/\A#{field.name}_ssm?\z/)
      end

      it "returns default values for all boolean attributes" do 
        expect(field.facet?).to eq(false)
        expect(field.searchable?).to eq(false)
        expect(field.sortable?).to eq(false)
        expect(field.multiple?).to eq(true)
        expect(field.full_text_searchable?).to eq(false)
        expect(field.required?).to eq(false)
        expect(field.hidden?).to eq(false)
        expect(field.stored_in_solr?).to eq(true)
        expect(field.controlled?).to eq(false)
        expect(field.work_title?).to eq(false)
        expect(field.date?).to eq(false)
      end

      it "is part of default display groups" do 
        expect(field.display_groups).to eq(["secondary"])
        expect(field.in_display_group?("primary")).to eq(false)
        expect(field.in_display_group?("secondary")).to eq(true)
        expect(field.search_result_display?).to eq(false)
      end
    end
    context "That has a role on our OAI feed" do
      let(:raw_array) {default_attributes.deep_merge({"OAI" => "DC:title"}) }
      let(:field) {described_class.new("testFieldname",raw_array)}
      it "parses OAI info correctly" do
        expect(field.oai_ns).to eq("dc")
        expect(field.oai_element).to eq("title")
        expect(field.oai?).to eq(true)
      end

    end

    context "with a predicate from a built-in vocabulary" do
      let(:raw_array) {default_attributes.deep_merge({"predicate" => "DC:title"}) }
      let(:field) {described_class.new("testFieldname",raw_array)}
      it "produces the correct predicate" do
        expect(field.predicate.to_s).to eq("http://purl.org/dc/terms/title")
      end
    end

    context "with a predicate from a user-defined vocabulary" do
      let(:raw_array) {default_attributes.deep_merge({"predicate" => "schema:identifier"}) }
      let(:field) {described_class.new("testFieldname",raw_array)}  
      it "produces the correct predicate" do
        expect(field.predicate).to eq("http://schema.org/identifier")
      end
    end
    
    context "from a controlled vocab" do
      let(:raw_array) {default_attributes.deep_merge({"vocabularies" => [{"authority" => "loc", "subauthority" => "names"},{"authority" => "local", "subauthority" => "agents"}]}) }
      let(:field) {described_class.new("testFieldname",raw_array)}
      it "correctly parses the vocabularies" do
        expect(field.controlled?).to eq(true)
        expect(field.vocabularies.count).to eq(2)
        expect(field.primary_vocabulary['subauthority']).not_to be_nil
      end
    end
    
    context "that's indexed as a date" do
      let(:raw_array) {default_attributes.deep_merge({"data_type" => "date", "searchable" => "true"})}
      let(:field) {described_class.new("testFieldname",raw_array)}
      it "sets the solr name properly" do
        expect(field.solr_names).to include("#{field.name}_dtsim")
      end
    end
    
    context "that's indexed as string or keyword" do
      let(:raw_array) {default_attributes.deep_merge({"data_type" => "keyword"})}
      let(:field) {described_class.new("testFieldname",raw_array)}
      it "sets the solr name properly" do
        expect(field.solr_name).to eq("#{field.name}_ssm")
      end
    end
    
    context "that is a facet" do
      let(:raw_array) {default_attributes.deep_merge({"facet" => true}) }
      let(:field) {described_class.new("testFieldname",raw_array)}
      
      it "sets up the index property and solr name properly" do
        expect(field.solr_facet_name).to eq("#{field.name}_sim")
        expect(field.facet?).to be(true)
      end
    end 
  end
end

