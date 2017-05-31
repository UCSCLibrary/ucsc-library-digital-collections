# Generated via
#  `rails generate curation_concerns:work Work`
module Hyrax
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    self.terms += [:resource_type]
    def primary_terms
      required_fields + [:description]
    end
  end
end
