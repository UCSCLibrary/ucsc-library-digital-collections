module Ucsc
  class CollectionSearchBuilder < Hyrax::CollectionSearchBuilder
    # Overrides parent method that wasn't working for our A-Z list.
    def add_sorting_to_solr(solr_parameters)
      return if solr_parameters[:q]
      solr_parameters[:sort] ||= "title_ssi asc"
    end
  end
end
