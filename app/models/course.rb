# Generated via
#  `rails generate hyrax:work Course`
class Course < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::ScoobySnacks::WorkModelBehavior
  include ::Bulkrax::Metadata
  
#  self.human_readable_type = 'Course'

  # Change this to restrict which works can be added as a child.
  self.valid_child_concerns = [Lecture,Work]

  validates :title, presence: { message: 'Each course must have a title.' }

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

  include ::Hyrax::BasicMetadata

end
