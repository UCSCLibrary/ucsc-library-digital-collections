# Generated via
#  `rails generate hyrax:work Lecture`
class Lecture < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScoobySnacks::WorkModelBehavior
  include ::Bulkrax::Metadata
  self.indexer = ::WorkIndexer
  
#  self.human_readable_type = 'Lecture'

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

#  include ::Hyrax::BasicMetadata

end
