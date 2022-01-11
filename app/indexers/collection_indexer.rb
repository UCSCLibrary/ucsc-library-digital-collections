# This controls how our application indexes collection metadata into Solr
# It is similar to work_indexer but simpler
require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class CollectionIndexer < Hyrax::CollectionIndexer
  THUMBNAIL_WIDTH = 300
  include ControlledIndexerBehavior
  include RepresentativeImageDimensionsIndexBehavior
  include AncestorCollectionBehavior
  include SortableFieldIndexerBehavior

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc = index_controlled_fields(solr_doc)
      solr_doc = index_representative_image_dimensions(solr_doc)

      # index the sortable fields
      solr_doc = index_sortable_fields(solr_doc)
      
      # index the titles a work's ancestor collections
      solr_doc = index_ancestor_titles(solr_doc)

      # index the field that bulkrax uses to keep track of imported/exported records
      solr_doc[Solrizer.solr_name('bulkrax_identifier', :facetable)] = object.bulkrax_identifier

      # index custom, non-controlled fields
      solr_doc[Solrizer.solr_name('collectionCallNumber', :stored_searchable)] = object.collectionCallNumber
      solr_doc[Solrizer.solr_name('extent', :stored_searchable)] = object.extent
      solr_doc[Solrizer.solr_name('donorProvenance', :stored_searchable)] = object.donorProvenance
      solr_doc[Solrizer.solr_name('harmfulLanguageStatement')] = object.harmfulLanguageStatement
      solr_doc[Solrizer.solr_name('publisherHomepage', :stored_searchable)] = object.publisherHomepage
      solr_doc[Solrizer.solr_name('rightsStatement', :stored_searchable)] = object.rightsStatement
      solr_doc[Solrizer.solr_name('rightsStatus', :stored_searchable)] = object.rightsStatus
      solr_doc[Solrizer.solr_name('accessRights', :stored_searchable)] = object.accessRights
      solr_doc[Solrizer.solr_name('dateCreatedDisplay')] = object.dateCreatedDisplay
      # end custom fields indexing
    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end
end
