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
      @file_set_presenters ||= member_presenters(((ordered_ids & file_set_ids) + grandchild_file_set_ids).uniq)
    end

    def ordered_ids
      super.reverse
    end

    private 

    def generate_member_av_file_list
      member_av_files = []
      ordered_work_ids.each do |work_id|
        work = SolrDocument.find(work_id)
        next if work.nil?
        i=1 #index for works with multiple audio files
        solr_docs = work.file_set_ids.map {|file_set_id| SolrDocument.find(file_set_id)}.select{|fs| fs.audio? || fs.video?}
        solr_docs.map do |doc|
          track_title = work.title.first
          track_title += " #{i}" if work.file_set_ids.count > 1
          member_av_files += [{id: doc.id, title: track_title}]
        end
      end
      member_av_files
    end

  end
end
