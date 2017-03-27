# Generated via
#  `rails generate curation_concerns:work Lecture`
module CurationConcerns
  class LectureForm < Sufia::Forms::WorkForm
    self.model_class = ::Lecture
    self.terms += [:resource_type,:date_digitized,:physical_format,:digital_extent,:digital_publisher_homepage]
    self.required_fields -= [:keyword,:rights]

    def primary_terms
      required_fields + [:subject,:resource_type,:digital_extent,:language]
    end

  end
end
