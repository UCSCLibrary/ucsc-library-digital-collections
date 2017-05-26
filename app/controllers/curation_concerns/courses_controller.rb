# Generated via
#  `rails generate curation_concerns:work Course`

module Hyrax
  class CoursesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    
    self.curation_concern_type = Course
    self.show_presenter = CourseShowPresenter
  end
end
