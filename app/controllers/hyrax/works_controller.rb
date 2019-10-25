module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Work
    self.show_presenter = Ucsc::WorkShowPresenter

    def manifest
      headers['Access-Control-Allow-Origin'] = '*'
      @cache_key = "manifest/#{presenter.id}"
      respond_to do |wants|
        wants.json { render json: cached_manifest }
        wants.html { render json: cached_manifest }
      end
    end

    def cached_manifest
      modified = presenter.solr_document.modified || DateTime.now
      @cache_key = "manifest/#{presenter.id}"
      if (entry = Rails.cache.send(:read_entry,@cache_key,{})).present?
        Rails.cache.delete(@cache_key) if (Time.at(entry.instance_variable_get(:@created_at)) < presenter.solr_document.modified)
      end
      Rails.cache.fetch(@cache_key){ manifest_builder.to_h.to_json}
    end
  end
end
