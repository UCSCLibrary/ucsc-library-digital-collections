require 'ucsc/oai/solr_document_wrapper'
module Ucsc
  module Oai
    class SolrDocumentProvider < BlacklightOaiProvider::SolrDocumentProvider

      def initialize(controller, options = {})
        super(controller, options)
        self.class.model = Ucsc::Oai::SolrDocumentWrapper.new(controller, options[:document])
      end
    end
  end
end
