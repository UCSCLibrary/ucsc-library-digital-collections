# Indexes booleans describing the type of work, so the presenter can quickly
# determine how to display the work on show and search results pages
module WorkTypeIndexerBehavior
  extend ActiveSupport::Concern

  def index_work_type(doc)
    return doc unless object.representative_id
    fs = FileSet.find(object.representative_id)

    doc["audio?_bsi"] = false
    doc["audio?_bsi"] = true if FileSet.audio_mime_types.include? fs.mime_type
    doc["audio?_bsi"] ||= true if object.resourceType.any?{|restype| ["audio","sound"].include? restype.to_s.downcase}
    doc["audio?_bsi"] ||= true if object.file_set_ids.any?{|id| SolrDocument.find(id).audio?}
    doc["audio?_bsi"] ||= true if object.member_work_ids.present? && object.member_work_ids.all?{|id| SolrDocument.find(id).audio?}

    doc["image?_bsi"] = false
    doc["image?_bsi"] = true if FileSet.image_mime_types.include? fs.mime_type
    doc["image?_bsi"] ||= true if object.resourceType.any?{|restype| ["photograph","image","picture","photo"].include? restype.to_s.downcase}
    doc["image?_bsi"] ||= true if object.file_set_ids.any?{|id| SolrDocument.find(id).image?}
    doc["image?_bsi"] ||= true if object.member_work_ids.present? && object.member_work_ids.all?{|id| SolrDocument.find(id).image?}

    return doc
  end

  def index_fileset_type(doc)
    doc["audio?_bsi"] = false
    doc["audio?_bsi"] = true if FileSet.audio_mime_types.include? object.mime_type
    doc["audio?_bsi"] ||= true if object.resourceType.any?{|restype| ["audio","sound"].include? restype.to_s.downcase}

    doc["image?_bsi"] = false
    doc["image?_bsi"] = true if FileSet.image_mime_types.include? object.mime_type
    doc["image?_bsi"] ||= true if object.resourceType.any?{|restype| ["photograph","image","picture","photo"].include? restype.to_s.downcase}

    return doc
  end

end
