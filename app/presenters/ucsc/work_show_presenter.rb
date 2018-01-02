module Ucsc
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior

    #Todo: add code to optionally overwrite attributes 
    # with parent work's info for some fields
    # for example:
    #   def creator
    #    return solr_document.creator unless solr_document.creator.nil?
    #    parent_work.creator unless parent_work.nil?
    #  end


    delegate :file_set_ids, to: :solr_document

    delegate :member_av_files, :ordered_work_ids, to: :member_presenter_factory


    def all_av_files
      @all_av_files ||= generate_all_av_file_list
    end

    private 

    def generate_all_av_file_list
      own_av_files = []
      file_set_ids.each do |id|
        fs = FileSet.find(id)
        next unless fs.audio? || fs.video?
        own_av_files << id
      end 
      own_av_files + member_av_files
    end

    def member_presenter_factory
      WorkMemberPresenterFactory.new(solr_document, current_ability, request)
    end
  end
end
