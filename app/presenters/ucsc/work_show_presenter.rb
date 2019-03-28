module Ucsc
  class WorkShowPresenter < Hyrax::WorkShowPresenter
    include ScoobySnacks::PresenterBehavior

    delegate :file_set_ids, to: :solr_document

    delegate :member_av_files, :ordered_work_ids, to: :member_presenter_factory

    def representative_presenter
      return nil unless representative_id
      file_set = SolrDocument.find(representative_id)
      return nil unless file_set
      Hyrax::FileSetPresenter.new(file_set,current_ability)
    end

    def universal_viewer?
      true
    end

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

    def image?
      return false unless representative_id
      solr_document.resourceType_label.each do |type|
        return true if type.to_s.downcase.include? "image"
      end
      return solr_document.image?
    end

    def page_title
      return super unless super == "Untitled"
      return titleAlternative.first unless titleAlternative.blank?
      return subseries.first unless subseries.blank?
      return series.first unless series.blank?
      return I18n.t('hyrax.product_name')
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
