# Generated via
#  `rails generate curation_concerns:work Flight`
module CurationConcerns
  class FlightForm < Sufia::Forms::WorkForm
    self.model_class = ::Flight
    self.terms += [:resource_type]

  end
end
