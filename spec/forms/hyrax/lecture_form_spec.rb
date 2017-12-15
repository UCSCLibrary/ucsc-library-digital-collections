# Generated via
#  `rails generate hyrax:work Lecture`
require 'rails_helper'

RSpec.describe Hyrax::LectureForm do

  let(:work) { Work.new }
  let(:form) { described_class.new(work, nil, controller) }
  let(:works) { [Work.new, FileSet.new, Work.new] }
  let(:controller) { instance_double(Hyrax::WorksController) }


  describe "#version" do
    before do
      allow(work).to receive(:etag).and_return('123456')
    end
    subject { form.version }

    it { is_expected.to eq '123456' }
  end


end
