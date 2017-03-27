# Generated via
#  `rails generate curation_concerns:work Course`
class Course < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Sufia::WorkBehavior

  self.human_readable_type = 'Course'
  # Change this to restrict which works can be added as a child.
  self.valid_child_concerns = [Lecture,Work]

  validates :title, presence: { message: 'Each course must have a title.' }

  property :date_digitized, predicate: ::RDF::Vocab::DC.modified do |index|
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

  
#  def self.indexer
#    CourseIndexer
#  end

end
