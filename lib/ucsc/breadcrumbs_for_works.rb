module Ucsc
  module BreadcrumbsForWorks
    extend ActiveSupport::Concern

    def default_trail 

      unless (col_id = presenter.member_of_collection_ids.first).nil?
        col = ::SolrDocument.find(col_id)
        add_breadcrumb col.title.first, "/records/#{col_id}"
      end

      unless (crs_id = presenter.solr_document.parent_course).nil?
        crs = ::SolrDocument.find(crs_id)
        add_breadcrumb col.title, "/records/#{crs_id}"
      end

      unless (wrk_id = presenter.solr_document.parent_work).nil?
        wrk = ::SolrDocument.find(wrk_id)
        add_breadcrumb wrk.title, "/records/#{wrk_id}"
      end

      add_breadcrumb presenter.to_s, main_app.polymorphic_path(presenter)

    end

    def add_breadcrumb_for_controller
#      add_breadcrumb presenter.title, "records/#{presenter.id}"
    end

    def add_breadcrumb_for_action
      
    end

  end
end
