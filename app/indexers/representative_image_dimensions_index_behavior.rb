module RepresentativeImageDimensionsIndexBehavior
  extend ActiveSupport::Concern

  def index_representative_image_dimensions(doc)
    return doc unless (file_set_id = object.thumbnail_id || Array(doc["hasRelatedImage_ssim"]).first).present?
    fs = SolrDocument.find(file_set_id)
    doc["width_is"] = fs.width
    doc["height_is"] = fs.height
    return doc
  end
  
end
