# Generated via
#  `rails generate curation_concerns:work AerialPhoto`
module CurationConcerns
  class AerialPhotoForm < Sufia::Forms::WorkForm
    self.model_class = ::AerialPhoto
    self.terms += [:resource_type]

  end
end
