# Generated via
#  `rails generate curation_concerns:work AerialPhoto`
class AerialPhoto < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  include Hyrax::WorkBehavior
  self.human_readable_type = 'Aerial Photo'
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

  property :feature, predicate: ::RDF::Vocab::DC11.description do |index|
    index.as :stored_searchable
  end

  property :street, predicate: ::RDF::Vocab::DC11.description do |index|
    index.as :stored_searchable
  end

  property :city, predicate: ::RDF::Vocab::DC11.subject do |index|
    index.as :stored_searchable, :facetable
  end

  property :scale, predicate: ::RDF::Vocab::DC11.description
  property :coordinates, predicate: ::RDF::Vocab::DC.spatial

end
