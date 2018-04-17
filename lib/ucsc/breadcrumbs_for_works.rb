module Ucsc
  module BreadcrumbsForWorks
    extend ActiveSupport::Concern

    def default_trail 

      hide_breadcrumbs = true;
      
      unless (col_id = presenter.member_of_collection_ids.first).nil?
        col = ::SolrDocument.find(col_id)
        add_breadcrumb col.title.first, "/records/#{col_id}"
        hide_breadcrumbs = false;
      end

      unless (crs = presenter.solr_document.parent_course).nil?
        crs_title = crs.title.is_a? String ? crs.title : crs.title.first
        add_breadcrumb crs_title, "/records/#{crs.id}"
        hide_breadcrumbs = false;
      end

      unless (wrk = presenter.solr_document.parent_work).nil?
        wrk_title = wrk.title.is_a? String ? wrk.title : wrk.title.first
        add_breadcrumb wrk_title, "/records/#{wrk.id}"
        hide_breadcrumbs = false;
      end

      add_breadcrumb presenter.to_s, main_app.polymorphic_path(presenter) unless hide_breadcrumbs

    end

    def add_breadcrumb_for_controller
#      add_breadcrumb presenter.title, "records/#{presenter.id}"
    end

    def add_breadcrumb_for_action
      
    end

  end
end
