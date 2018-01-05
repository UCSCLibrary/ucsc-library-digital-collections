# coding: utf-8
require 'rails_helper'

RSpec.describe BulkMetadata::Ingest, type: :model do

  context "When creating a brand new ingest" do       
    it "there should be zero rows of any status." do 
      ingest = BulkMetadata::Ingest.new
      expect(ingest.numParsed).to eq 0
      expect(ingest.numUnparsed).to eq 0
      expect(ingest.numErrors).to eq 0
      expect(ingest.numIngesting).to eq 0
    end
  end

  context "When parsing a csv file with in ingest specification line" do       
    ingest = BulkMetadata::Ingest.new
      it "the spec line should be recognized and the name should be populated from it" do
        ingest.filename = Rails.root.join "spec/fixtures/files/sample_ingest_specline.csv"
        expect(ingest.hasSpecLine?).to eq true
        ingest.parseSpecLine file_fixture("sample_ingest_specline.csv").read
        expect(ingest.name).to eq "Test Sample Ingest"
    end

      it "the parseIngestSpec method populate the ingest name from the spec line" do
    end

  end

#  pending "add more test beyond nominal to #{__FILE__}"
end
