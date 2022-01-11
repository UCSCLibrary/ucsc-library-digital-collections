# This is the main indexing class
# where we customize how our solr index is created from a fedora object
require 'nokogiri'
require 'open-uri'
require 'linkeddata'
class WorkIndexer < Hyrax::WorkIndexer
  THUMBNAIL_WIDTH = 300

  # This contains all the custom code for indexing controlled vocabulary fields
  include ControlledIndexerBehavior

  # This contains all the custom code for indexing image dimensions,
  # which is important for generating thumbnail links efficiently
  include RepresentativeImageDimensionsIndexBehavior

  # This indexes all of the ancestors of an object (parents, parent's parents, etc)
  include AncestorCollectionBehavior
  include SortableFieldIndexerBehavior

  # This is the main method to generate a solr document from a fedora object.
  # The original fedora object is referred to here by 'object'
  def generate_solr_document
    # We start with the Hyrax indexer's result and modify it
    super.tap do |solr_doc|
      
      # We added indexes for file set ids and member ids,
      # so that we can display them efficiently in
      # work show pages, iiif manifests, etc
      solr_doc['file_set_ids_ssim'] = object.file_set_ids
      solr_doc['member_ids_ssim'] = object.ordered_member_ids

      # This block collects the representative images of all
      # child image filesets and child image works and indexes them under 'hasRelatedImage_ssim'
      object.ordered_member_ids.each do |member_id|
        next unless (member = SolrDocument.find(member_id)).image?
        solr_doc["hasRelatedImage_ssim"] ||= []
        case member['has_model_ssim'].first
        when "FileSet"
          solr_doc["hasRelatedImage_ssim"] << member_id
          (solr_doc["file_set_ids_ssim"] ||= []) << member_id 
        when "Work"
          solr_doc["hasRelatedImage_ssim"]  += (member["hasRelatedImage_ssim"] || [])
        end
      end
      # Make sure we haven't double-counted any related images
      solr_doc["hasRelatedImage_ssim"] = (solr_doc["hasRelatedImage_ssim"] || []).uniq
      solr_doc["file_set_ids_ssim"] = (solr_doc["file_set_ids_ssim"] || []).uniq

      # the method 'index_controlled_fields' is defined in controlled_indexer_behavior.rb
      # It resolves metadata URLS from externally controlled vocabularies and indexes the associated labels
      solr_doc = index_controlled_fields(solr_doc)

      # The inherit fields method controls inheritance of metadata from parent works
      solr_doc = inherit_fields(solr_doc)

      # index the sortable fields
      solr_doc = index_sortable_fields(solr_doc)

      # This merges several related fields (different types of subjects) into a collective field (subject).
      # I think that merging fields is now supported by blacklight on the display end. Look in to that?
      solr_doc = merge_fields(:subject, [:subjectTopic,:subjectName,:subjectTemporal,:subjectPlace], solr_doc, :stored_searchable)
      solr_doc = merge_fields(:subject, [:subjectTopic,:subjectName,:subjectTemporal,:subjectPlace], solr_doc, :facetable)
      solr_doc = merge_fields(:callNumber, [:itemCallNumber,:collectionCallNumber,:boxFolder], solr_doc)
      
      # If this work has a related images but the thumbnail has not been set correctly, set the thumbnail
      if (image_ids = solr_doc['hasRelatedImage_ssim']).present?
        if solr_doc['thumbnail_path_ss'].blank? or solr_doc['thumbnail_path_ss'].to_s.downcase.include?("work")
          solr_doc['thumbnail_path_ss'] = "/downloads/#{image_ids.last}?file=thumbnail"
        end
      end

      # index the dimensions of a work's representative image for display purposes
      solr_doc = index_representative_image_dimensions(solr_doc)

      # index the titles a work's ancestor collections
      solr_doc = index_ancestor_titles(solr_doc)

      # index the field that bulkrax uses to keep track of imported/exported records
      solr_doc[Solrizer.solr_name('bulkrax_identifier', :facetable)] = object.bulkrax_identifier

      solr_doc
    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end

  # This method controls inheritance of metadata from parent works or collections
  # Metadata inheritance can also happen when the work is saved, in which case the
  # inherited metadata is stored in Fedora and indexed normally.
  # This method comes in to play when you want the inherited metadata to display for users
  # but not to be part of the preservation record.
  def inherit_fields solr_doc
    # abort unless the object is specifically flagged for this type of inheritance
    return solr_doc unless Array(object.metadataInheritance).first.to_s.downcase.include?("index")
    # abort unless the object has a parent in the system
    return solr_doc unless object.member_of.present?
    object.member_of.each do |parent_work|
      parent_doc = SolrDocument.find(parent_work.id)
      # Loop through all inheritable fields
      ScoobySnacks::METADATA_SCHEMA.inheritable_fields.each do |field|
        # Do not inherit if the child work has independent data
        next if solr_doc[field.solr_name].present?
        solr_doc[field.solr_name] = parent_doc[field.solr_name]
      end
    end
    return solr_doc
  end

  # This is my custom code to define a new index based on multiple solr fields
  # I believe that this functionality is now supported natively in solr,
  # and we should look into taking advantage of that.
  def merge_fields(merged_field_name, fields_to_merge, solr_doc, solr_descriptor = :stored_searchable)
    merged_field_contents = []
    fields_to_merge.each do |field_name|
      field = schema.get_field(field_name.to_s)
      if (indexed_field_contents = solr_doc[field.solr_name])
        merged_field_contents.concat(indexed_field_contents)
      end
    end
    solr_name = Solrizer.solr_name(merged_field_name, solr_descriptor)
    solr_doc[solr_name] = merged_field_contents unless merged_field_contents.blank?
    return solr_doc
  end
end
