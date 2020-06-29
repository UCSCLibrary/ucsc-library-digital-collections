class FileSetIndexer < Hyrax::FileSetIndexer
  include AncestorCollectionBehavior

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["file_id_ss"] = object.original_file.id
      solr_doc["ancestor_ids_ssim"] = ancestor_ids(object)
      visibilities = solr_doc["ancestor_ids_ssim"].map{|id| SolrDocument.find(id).visibility}
      if (special_vis = (['request','campus'] & visibilities)).present?
        solr_doc["visibility_ssi"] = special_vis.first
      elsif object.parent_works.all?{|parent| parent.visibility == 'open'}
        solr_doc["visibility_ssi"] = "open"
      else
        solr_doc["visibility_ssi"] = "restricted"
      end
    end
  end
end
