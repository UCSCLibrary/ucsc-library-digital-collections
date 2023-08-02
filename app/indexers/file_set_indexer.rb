# We customize how filesets are indexed
# 
class FileSetIndexer < Hyrax::FileSetIndexer
  include AncestorCollectionBehavior
  include WorkTypeIndexerBehavior
  def generate_solr_document
    super.tap do |solr_doc|
      # Indexing the original file may no longer be necessary
      # now that we use the image server exclusively.
      # We should make sure it is not used before removing it. 
      if object.original_file.present?
        solr_doc["file_id_ss"] = object.original_file.id
      end

      # Indexing the file set's ancestors is important for permissions reasons
      solr_doc["ancestor_ids_ssim"] = ancestor_ids(object)

      #  
      visibilities = solr_doc["ancestor_ids_ssim"].map{|id| SolrDocument.find(id).visibility}
      # We added the custom visibility options 'request' and 'campus'
      # and this code is necessary to handle them correctly
      if (special_vis = (['request','campus'] & visibilities)).present?
        solr_doc["visibility_ssi"] = special_vis.first
      # always treat a fileset as public if all its parents are public
        # (there is no use case for a private fileset in a public work,
        # and it is easy to accidentally leave a fileset private and cause errors)
      elsif object.parent_works.all?{|parent| parent.visibility == 'open'}
        solr_doc["visibility_ssi"] = "open"
      else
        solr_doc["visibility_ssi"] = "restricted"
      end

      # index booleans for the type of fileset, which helps determine the work type
      solr_doc = index_fileset_type(solr_doc)
    end
  end
end
