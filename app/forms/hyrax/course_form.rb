# Generated via
#  `rails generate hyrax:work Course`
module Hyrax
  class CourseForm < Hyrax::Forms::WorkForm
    self.model_class = ::Course
    self.terms += [:resource_type]
  end
end
