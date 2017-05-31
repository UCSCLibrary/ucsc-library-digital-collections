# Generated via
#  `rails generate curation_concerns:work Flight`
class Flight < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include Hyrax::WorkBehavior
  self.human_readable_type = 'Flight'
  # Change this to restrict which works can be added as a child.
  #self.valid_child_concerns = ['']

  validates :title, presence: { message: 'Each flight must have a title.' }

  property :date_created, predicate: ::RDF::Vocab::DC.created do |index|
    index.as :stored_searchable, :facetable
  end
  
  property :coordinates, predicate: ::RDF::Vocab::DC.spatial

  property :county, predicate: ::RDF::Vocab::DC11.subject do |index|
    index.as :facetable
  end

  property :physical_format, predicate: ::RDF::Vocab::DC.medium do |index|
    index.as :facetable
  end

  property :call_number, predicate: ::RDF::Vocab::DC.medium

  def physical_extent
    return self.aerial_photos.length
  end

end
