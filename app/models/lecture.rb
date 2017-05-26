# Generated via
#  `rails generate curation_concerns:work Lecture`
class Lecture < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include Hyrax::WorkBehavior
  self.human_readable_type = 'Lecture'
  # Change this to restrict which works can be added as a child.
  self.valid_child_concerns = [Work]

  validates :title, presence: { message: 'Each lecture must have a title.' }

  property :date_digitized, predicate: ::RDF::Vocab::DC.date do |index|
    index.as :stored_searchable
  end

  property :physical_format, predicate: ::RDF::Vocab::DC.medium do |index|
    index.as :stored_searchable
  end

  property :digital_extent, predicate: ::RDF::Vocab::DC.extent do |index|
    index.as :stored_searchable
  end

  property :digital_publisher_homepage, predicate: ::RDF::Vocab::DC.publisher do |index|
    index.as :stored_searchable
  end


end
