class CatalogSearchBuilder < Hyrax::CatalogSearchBuilder 
    include BlacklightAdvancedSearch::AdvancedSearchBuilder
    self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]

    self.default_processor_chain.delete :show_works_or_works_that_contain_files
end
