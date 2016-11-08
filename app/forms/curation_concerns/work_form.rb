# Generated via
#  `rails generate curation_concerns:work Work`
module CurationConcerns
  class WorkForm < Sufia::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [:resource_type]
    def primary_terms
      required_fields + [:description]
    end
  end
end
