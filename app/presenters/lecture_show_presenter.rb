class LectureShowPresenter < Hyrax::WorkShowPresenter

  delegate :file_set_ids,:digital_extent,:parent_course, to: :solr_document 

  def creator
    return solr_document.creator unless solr_document.creator.nil?
    parent_course.creator unless parent_course.nil?
  end

  def digital_publisher_homepage
    return solr_document.digital_publisher_homepage unless solr_document.digital_publisher_homepage.nil?
    parent_course.digital_publisher_homepage unless parent_course.nil?
  end

  def language
    return solr_document.language unless solr_document.language.empty?
    parent_course.language unless parent_course.nil?
  end

  def physical_format
    return solr_document.physical_format unless solr_document.physical_format.nil?
    parent_course.physical_format unless parent_course.nil?
  end

  def date_digitized
    return solr_document.date_digitized unless solr_document.date_digitized.nil?
    parent_course.date_digitized unless parent_course.nil?
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
