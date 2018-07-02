module Ucsc
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior

    delegate :file_set_ids, :display_image_url,:display_image_path, to: :solr_document

    delegate :member_av_files, :ordered_work_ids, to: :member_presenter_factory

    def representative_presenter
      return nil unless representative_id
      file_set = SolrDocument.find(representative_id)
      return nil unless file_set
      Hyrax::FileSetPresenter.new(file_set,current_ability)
    end

    def all_av_files
      @all_av_files ||= generate_all_av_file_list
    end


    def image?
      return true if solr_document.resourceType_label.include?("Still Image")
      return true if solr_document.resourceType_label.include?("Image")
      return false unless representative_id
      return solr_document.image?
    end

    private 

    def generate_all_av_file_list
      own_av_files = []
      file_set_ids.each do |id|
        fs = SolrDocument.find(id)
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
