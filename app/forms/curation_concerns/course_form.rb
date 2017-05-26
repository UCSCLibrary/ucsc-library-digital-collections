# Generated via
#  `rails generate curation_concerns:work Course`
module Hyrax
  class CourseForm < Hyrax::Forms::WorkForm

    self.model_class = ::Course
    self.terms += [:resource_type]

    self.terms += [:resource_type,:date_digitized,:physical_format,:digital_extent,:digital_publisher_homepage]
    self.required_fields -= [:keyword,:rights]

    def primary_terms
      required_fields + [:date_created,:date_digitized,:subject,:resource_type,:physical_format,:digital_extent,:language,:rights,:digital_publisher_homepage,:source]
    end

  end
end
