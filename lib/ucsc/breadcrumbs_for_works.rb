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
        add_breadcrumb col.title, "/records/#{crs_id}"
        hide_breadcrumbs = false;
      end

      unless (wrk = presenter.solr_document.parent_work).nil?
        add_breadcrumb wrk.title, "/records/#{wrk_id}"
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
