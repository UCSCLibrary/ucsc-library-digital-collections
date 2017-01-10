class LectureShowPresenter < Sufia::WorkShowPresenter
  def file_set_ids
    solr_document.file_set_ids
  end
end
