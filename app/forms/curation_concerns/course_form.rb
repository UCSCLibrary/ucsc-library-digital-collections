# Generated via
#  `rails generate curation_concerns:work Course`
module CurationConcerns
  class CourseForm < Sufia::Forms::WorkForm
    self.model_class = ::Course
    self.terms += [:resource_type]

  end
end
