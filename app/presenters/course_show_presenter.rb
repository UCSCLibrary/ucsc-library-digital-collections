class CourseShowPresenter < Sufia::WorkShowPresenter
  def lecture_files
    lecture_files = []
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(ordered_work_ids)
    lectures = ActiveFedora::SolrService.instance.conn.get(
        ActiveFedora::SolrService.select_path,
        params: { fq: query})["response"]["docs"].map { |res| SolrDocument.new(res) }
    ordered_work_ids.each do |lecture_id|
      lecture = lectures.find { |lecture| lecture.id == lecture_id }
      i=1 #index for lectures with multiple audio files
      lecture.file_set_ids.each do |file_set_id|
        track_title = lecture.title.first
        track_title += " i" if lecture.file_set_ids.count > 1
        lecture_files += [{id: file_set_id, title: track_title}]
      end
    end
    lecture_files
  end

  def ordered_work_ids
    @ordered_work_ids ||= ordered_ids - file_set_ids
  end

end
