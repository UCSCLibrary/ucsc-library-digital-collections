class CourseShowPresenter < Sufia::WorkShowPresenter
  def lecture_files
    lecture_files = []
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(solr_document.member_ids)
    results = ActiveFedora::SolrService.instance.conn.get(
        ActiveFedora::SolrService.select_path,
        params: { fq: query})
    results["response"]["docs"].each do |member|
      i=1
      member_solr = SolrDocument.new(member)
      member_solr.file_set_ids.each do |file_set_id|
        track_title = member_solr.title.first
        track_title += " i" if member_solr.file_set_ids.count > 1
        lecture_files += [{id: file_set_id, title: track_title}]
      end
    end
    lecture_files
  end
end
