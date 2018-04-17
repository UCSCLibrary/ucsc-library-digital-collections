class Ucsc::CatalogSearchBuilder < Hyrax::CatalogSearchBuilder 
    self.default_processor_chain.delete :show_works_or_works_that_contain_files
end
