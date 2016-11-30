# Generated via
#  `rails generate curation_concerns:work AerialPhoto`
module CurationConcerns
  class AerialPhotoForm < Sufia::Forms::WorkForm
    self.model_class = ::AerialPhoto
    self.terms += [:resource_type,:feature,:street,:city,:scale,:coordinates]
    self.required_fields -= [:creator,:keyword,:rights]
    def primary_terms
      required_fields + [:feature,:street,:city,:subject,:scale,:source,:coordinates]
    end

  end
end
