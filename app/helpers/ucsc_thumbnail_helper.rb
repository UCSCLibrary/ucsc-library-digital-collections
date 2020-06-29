module UcscThumbnailHelper

  def square_thumbnail_region(doc, size="150,")
    doc = SolrDocument.find(doc) if doc.is_a?(String)
    size = "#{size}," unless (size.is_a(String) && size.include?(','))
    hh = Array(doc.height).first.to_i
    ww = Array(doc.width).first.to_i
    if hh > ww
      square_region = "0,#{(hh-ww)/2},#{ww},#{ww}"
    else
      square_region =  "#{(ww-hh)/2},0,#{hh},#{hh}"
    end
  end

  def square_thumbnail_url(doc,size="150,")
    square_region = square_thumbnail_region(doc, size)
    thumbnail_url(doc.id, {region: square_region, size: size})
  end

  
  def thumbnail_url(id, size="150,")
    image_config = size.is_a?(String) ? {size: size} : size
      region = image_config[:region] || "full"
      rotation = image_config[:rotation] || "0"
      size = image_config[:size]
      return Hyrax.config.iiif_image_url_builder.call(id,"nil",size,region,rotation)
  end

end
