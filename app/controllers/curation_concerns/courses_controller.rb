# Generated via
#  `rails generate curation_concerns:work Course`

module CurationConcerns
  class CoursesController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = Course
  end
end
