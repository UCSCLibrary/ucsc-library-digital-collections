module Workflow
    # Finds a list of works that we can perform a workflow action on
  class StatusListService < Hyrax::Workflow::StatusListService
      # @param context [#current_user, #logger]
      # @param filter_condition [String] a solr filter
      def initialize(context, filter_condition, max_rows = 1000)
        @context = context
        @filter_condition = filter_condition
        @max_rows = max_rows
      end

      def user
        begin
          return context.current_user
        rescue NoMethodError
          return User.first
        end
      end

      def count
        actionable_roles = roles_for_user
        ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query(actionable_roles), rows: 0})["response"]["numFound"]
      end

      def first(num)
        solr_documents.first(num)
      end

      private

        def search_solr
          actionable_roles = roles_for_user
          Rails.logger.debug("Actionable roles for #{user.user_key} are #{actionable_roles}")
          return [] if actionable_roles.empty?
          Hyrax::WorkRelation.new.search_with_conditions(query(actionable_roles), rows: @max_rows, method: :post)
        end

    end
end
