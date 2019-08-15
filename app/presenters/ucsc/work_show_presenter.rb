module Ucsc
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior

    delegate :file_set_ids, :image?, to: :solr_document

    delegate :member_av_files, :ordered_work_ids, to: :member_presenter_factory

    def representative_presenter
      return nil unless representative_id
      file_set = SolrDocument.find(representative_id)
      return nil unless file_set
      Hyrax::FileSetPresenter.new(file_set,current_ability)
    end

    def universal_viewer?
      "click"
    end

    # We should delegate this to the solrDocument, which should have it already indexed (for works at least).
    def display_image_url
      if representative_id
        return nil unless current_ability.can?(:read, representative_id)
        representative_image = SolrDocument.find(representative_id)
        return nil unless representative_image.image?
        representative_image.display_image_url
      elsif solr_document.image?
        solr_document.display_image_url
      end
    end

    def all_av_files
      @all_av_files ||= generate_all_av_file_list
    end


    def page_title
      "#{solr_document.title.first} | UCSC Digital Library Collections"
    end

    delegate :titleAlternative, :subseries, :series, to: :solr_document

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


    def find_renderer_class(name)
      return ::FacetedAttributeRenderer if name == :faceted
      super
    end

  end
end
