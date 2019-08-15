module Ucsc
  class WorkMemberPresenterFactory < Hyrax::MemberPresenterFactory
    
    self.work_presenter_class = WorkShowPresenter

    delegate :grandchild_file_set_ids, to: :@work

    def member_av_files
      @member_av_files ||= generate_member_av_file_list()
    end

    def ordered_work_ids
      @ordered_work_ids ||= (ordered_ids - file_set_ids)
    end

    def file_set_presenters
      @file_set_presenters ||= member_presenters((ordered_ids & file_set_ids) + grandchild_file_set_ids)
    end

    private 

    def generate_member_av_file_list
      member_av_files = []
      query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids(ordered_work_ids)
      works = ActiveFedora::SolrService.instance.conn.get(
        ActiveFedora::SolrService.select_path,
        params: { fq: query, rows: 1000})["response"]["docs"].map { |res| SolrDocument.new(res) }
      ordered_work_ids.each do |work_id|
        work = works.find { |work| work.id == work_id }
        next if work.nil?
        i=1 #index for works with multiple audio files
        work.file_set_ids.each do |file_set_id|
          fs = SolrDocument.find(file_set_id)
          next unless fs.audio? || fs.video?
          track_title = work.title.first
          track_title += " #{i}" if work.file_set_ids.count > 1
          member_av_files += [{id: file_set_id, title: track_title}]
        end
      end
      member_av_files
    end

  end
end
