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


      # index custom fields
      solr_doc[Solrizer.solr_name('collection_call_number', :stored_searchable)] = object.collection_call_number

      solr_doc[Solrizer.solr_name('extent'), :stored_searchable] = object.extent

      solr_doc[Solrizer.solr_name('donor_provenance'), :stored_searchable] = object.donor_provenance

      solr_doc[Solrizer.solr_name('harmful_language_statement')] = object.harmful_language_statement

      solr_doc[Solrizer.solr_name('publisher_homepage'), :stored_searchable] = object.publisher_homepage

      solr_doc[Solrizer.solr_name('rights_holder'), :stored_searchable] = object.rights_holder

      solr_doc[Solrizer.solr_name('rights_status'), :stored_searchable] = object.rights_status

      solr_doc[Solrizer.solr_name('subject_name', :stored_searchable)] = object.subject_name

      solr_doc[Solrizer.solr_name('subject_place', :stored_searchable)] = object.subject_place

      solr_doc[Solrizer.solr_name('subject_topic', :stored_searchable)] = object.subject_topic

      solr_doc[Solrizer.solr_name('subject_title', :stored_searchable)] = object.subject_title

      solr_doc[Solrizer.solr_name('date_created_display'), :stored_searchable] = object.date_created_display

      # end custom fields indexing

    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end
  
end
