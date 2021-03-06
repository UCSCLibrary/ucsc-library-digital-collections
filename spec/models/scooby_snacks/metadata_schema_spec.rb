require 'rails_helper'
RSpec.describe ScoobySnacks::MetadataSchema do
    describe "A sample metadata schema" do
      let (:schema) {described_class.new(schema_config_path: file_fixture("sample_metadata_schema.yml").to_s)}

      it "correctly parses namespaces" do
        expect(schema.namespaces).to be_a Hash
        expect(schema.namespaces['edm']).to eq("http://www.europeana.eu/schemas/edm/")
        expect(schema.namespaces['purlOnt']).to eq("http://purl.org/ontology/")
      end

      it "populates an array of fields from the config file" do
        expect(schema.fields.count).to eq(40)
        expect(schema.fields.keys.first).to be_a(String)
        expect(schema.fields.values.first).to be_a(ScoobySnacks::Field)
        expect(schema.fields.values.last).to be_a(ScoobySnacks::Field)
      end

      it "defines display group methods" do
        expect(schema.primary_display_fields).to be_a(Array)
        expect(schema.primary_display_field_names).to include('title')
        expect(schema.primary_display_field_names).not_to include('staffNote')
      end

      it "defines binary property group methods" do
        expect(schema.searchable_fields).to be_a(Array)
        expect(schema.searchable_field_names).to include('creator')
        expect(schema.searchable_field_names).not_to include('staffNote')
      end

      it "returns fields by name or label" do
        expect(schema.get_field("title")).to be_a(ScoobySnacks::Field)
        expect(schema.get_field("Accession Number")).to be_a(ScoobySnacks::Field)
      end

      it "generates a reasonable list of full text searchable fields for default searches" do
        expect(schema.default_text_search_solrized_field_names).to include("all_text_timv")
        expect(schema.default_text_search_solrized_field_names).to include("creator_tesim")
        expect(schema.default_text_search_solrized_field_names).not_to include("theme_tesm")
        expect(schema.default_text_search_solrized_field_names).not_to include("originalPublisher_tesm")
      end

    end

end

