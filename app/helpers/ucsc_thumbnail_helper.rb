module UcscThumbnailHelper

  def square_thumbnail_region(doc, size="150,")
    doc = SolrDocument.find(doc) if doc.is_a?(String)
    size = "#{size}," unless (size.is_a?(String) && size.include?(','))
    hh = Array(doc.height).first.to_i
    ww = Array(doc.width).first.to_i
    if hh > ww
      square_region = "0,#{(hh-ww)/2},#{ww},#{ww}"
    else
      square_region =  "#{(ww-hh)/2},0,#{hh},#{hh}"
    end
  end

  def square_thumbnail_url(doc,size="150,")
    # unless doc is a fileset, use the representative fileset id
    unless doc["has_model_ssim"] == "FileSet"
      fs_id = doc.representative_id || doc.thumbnail_id
    end
    # If the width and height for a non-fileset doc aren't indexed, retrieve the fileset doc
    if doc.width.present? && doc.height.present?
      square_region = square_thumbnail_region(doc, size)
    else
      square_region = square_thumbnail_region(SolrDocument.find(fs_id), size)
    end
    return Hyrax.config.iiif_image_url_builder.call(fs_id,"nil",size,square_region)
  end

  def self.thumbnail_url(id,size="150,")
    image_config = size.is_a?(String) ? {size: size} : size
    region = image_config[:region] || "full"
    rotation = image_config[:rotation] || "0"
    size = image_config[:size]
    return Hyrax.config.iiif_image_url_builder.call(id,"nil",size,region,rotation)
  end

  def thumbnail_url(id, size="150,")
    self.thumbnail_url(id,size)
  end

  def ucsc_thumbnail_tag(doc,image_options)
    url = if image_options[:legacy]
            doc.thumbnail_path
          elsif image_options[:square]
            square_thumbnail_url(doc,(image_options[:size] || ucsc_default_thumb_size))
          else
            thumbnail_url(doc,(image_options[:size] || ucsc_default_thumb_size))
          end
    view_context.image_tag url, image_options
  end
    
  def ucsc_default_thumb_size
    150
  end
    
end
