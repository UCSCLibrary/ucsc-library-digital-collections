# Generated via
#  `rails generate curation_concerns:work Flight`
module CurationConcerns
  class FlightForm < Sufia::Forms::WorkForm
    self.model_class = ::Flight
#    self.primary_terms += [:coordinates,:county,:physical_format]
    self.terms += [:resource_type,:coordinates,:county,:physical_format]
    self.required_fields -= [:keyword,:rights]
    def primary_terms
      required_fields + [:contributor,:date_created,:description,:coordinates,:county,:subject,:physical_format,:call_number,:source]
    end

  end
end
