class LectureShowPresenter < Sufia::WorkShowPresenter

  delegate :digital_extent, to: :solr_document  

  def digital_publisher_homepage
    return solr_document.digital_publisher_homepage unless solr_document.digital_publisher_homepage.nil?
    parent_course_solr_document.digital_publisher_homepage
  end

  def language
    return solr_document.language unless solr_document.language.empty?
    parent_course_solr_document.language
  end

  def physical_format
    return solr_document.physical_format unless solr_document.physical_format.nil?
    parent_course_solr_document.physical_format
  end

  def date_digitized
    return solr_document.date_digitized unless solr_document.date_digitized.nil?
    parent_course_solr_document.date_digitized
  end

  def parent_course_solr_document
    return @parent_course_solr_document unless @parent_course_solr_document.nil?
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("member_ids" => id, "has_model" => "Course")
    response = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 1})["response"]["docs"][0]
    @parent_course_solr_document = SolrDocument.new(response)
  end

  def file_set_ids
    solr_document.file_set_ids
  end

  def representative_id
    #For now, this shows the normal representative media
    # for editors and shows nothing for others
    if editor?
      super
    else
      nil
    end
    #TODO: have a separate permission for downloading streaming
    # media. If the user does not have this permissions, then
    # use the first attached image, if any, or return nothing
  end
  
end
