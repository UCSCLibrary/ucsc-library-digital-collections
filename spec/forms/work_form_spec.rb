require 'rails_helper'

RSpec.describe Hyrax::WorkForm do
 
  before(:all)  do 
    @usr = User.find_by_email('test-email') || User.create(email:"test-email")
    @wrk = Work.create(depositor: @usr.email, title:["test title"])
    @frm = described_class.new(@wrk, nil, nil) 
  end

  after(:all)  do 
    @wrk.destroy
  end

  describe "#required_fields" do
    subject { @frm.required_fields }
    it { is_expected.to eq(ScoobySnacks::METADATA_SCHEMA.required_field_names.map{|name| name.to_sym}) }
  end

  describe "#primary_terms" do
    subject { @frm.primary_terms }
    it { is_expected.to include(:title) }
    it { is_expected.to include(:accessRights) }
    it { is_expected.not_to include(:rightsStatus) }
  end

  describe "#secondary_terms" do
    subject { @frm.secondary_terms }
    it { is_expected.to include(:source) }
    it { is_expected.not_to include(:accessRights) }
  end

  describe "#terms" do
    subject { described_class.terms }
    it { is_expected.to include(:title) }
    it { is_expected.to include(:source) }
    it { is_expected.to include(:accessRights) }
  end


end
