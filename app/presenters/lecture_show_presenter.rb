class LectureShowPresenter < Sufia::WorkShowPresenter
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
