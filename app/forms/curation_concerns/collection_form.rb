module CurationConcerns
  class CollectionForm < Sufia::Forms::CollectionForm
    self.secondary_terms += [:publisher_website,:rights_holder]
  end
end
