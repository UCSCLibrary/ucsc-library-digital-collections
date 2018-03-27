
module Ucsc
  module Oai
    class SolrDocumentWrapper < BlacklightOaiProvider::SolrDocumentWrapper

      def earliest
        builder = @controller.search_builder.merge(fl: solr_timestamp, sort: "#{solr_timestamp} asc", rows: 1)
        response = @controller.repository.search(builder)
        response.documents.first.timestamp
      end

      def latest
        builder = @controller.search_builder.merge(fl: solr_timestamp, sort: "#{solr_timestamp} desc", rows: 1)
        response = @controller.repository.search(builder)
        response.documents.first.timestamp
      end
      

      def find(selector, options = {})
        return next_set(options[:resumption_token]) if options[:resumption_token]

        if selector == :all
#          abort(conditions)
          response = @controller.repository.search(conditions(options))

          if limit && response.total > limit
            return select_partial(BlacklightOaiProvider::ResumptionToken.new(options.merge(last: 0), nil, response.total))
          end
          response.documents
        else
          @controller.fetch(selector).first.documents.first
        end
      end

      private

      def conditions(options) # conditions/query derived from options
        query = @controller.search_builder.merge(sort: "#{solr_timestamp} asc", rows: limit).query

        if options[:from].present? || options[:until].present?
          query.append_filter_query(
            "#{solr_timestamp}:[#{solr_date(options[:from])} TO #{solr_date(options[:until]).gsub('Z', '.999Z')}]"
          )
        end
        query.append_filter_query(@set.from_spec(options[:set])) if options[:set].present?
        query = query.merge(fq:"has_model_ssim:(Work OR Course)")
        query
      end

    end
  end
end
