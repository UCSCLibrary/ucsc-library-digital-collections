# frozen_string_literal: true

module Bulkrax
  module Metadata
    extend ActiveSupport::Concern

    included do
      property :bulkrax_identifier, predicate: ::RDF::URI.new('http://digitalcollections.library.ucsc.edu/terms/bulkraxIdentifier'), multiple: false do |index|
        index.as :stored_searchable, :facetable
      end
    end
  end
end
