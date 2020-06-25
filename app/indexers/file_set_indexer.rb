class FileSetIndexer < Hyrax::FileSetIndexer
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["file_id_ss"] = object.original_file_id
      solr_doc["ancestor_ids_ssim"] = ancestor_ids(solr_doc)
      visibilities = solr_doc["ancestor_ids_ssim"].map{|id| SolrDocument.find(id).visibility}
      if (special_vis = (['request','campus'] & visibilities)).present?
        solr_doc["visibility_ssi"] = special_vis.first
      else
        solr_doc["visibility_ssi"] = "open" if solr_doc.parent_work.visibility == 'open'
      end
    end
  end
end
