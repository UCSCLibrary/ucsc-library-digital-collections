require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class CollectionIndexer < Hyrax::CollectionIndexer
  THUMBNAIL_WIDTH = 300
  include ControlledIndexerBehavior

  def generate_solr_document
    super.tap do |solr_doc|
      puts "running collection indexer"
      solr_doc = index_controlled_fields(solr_doc)
    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end
  
end
