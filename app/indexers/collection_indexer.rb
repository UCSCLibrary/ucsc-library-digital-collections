require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class CollectionIndexer < Hyrax::CollectionIndexer
  THUMBNAIL_WIDTH = 300
  include ControlledIndexerBehavior
  include RepresentativeImageDimensionsIndexBehavior

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc = index_controlled_fields(solr_doc)
      solr_doc = index_representative_image_dimensions(solr_doc)
    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end
  
end
