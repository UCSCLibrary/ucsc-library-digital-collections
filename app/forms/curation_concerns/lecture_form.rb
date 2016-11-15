# Generated via
#  `rails generate curation_concerns:work Lecture`
module CurationConcerns
  class LectureForm < Sufia::Forms::WorkForm
    self.model_class = ::Lecture
    self.terms += [:resource_type]

  end
end
