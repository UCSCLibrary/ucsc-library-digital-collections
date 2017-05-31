# Generated via
#  `rails generate hyrax:work Lecture`
module Hyrax
  class LectureForm < Hyrax::Forms::WorkForm
    self.model_class = ::Lecture
    self.terms += [:resource_type]
  end
end
