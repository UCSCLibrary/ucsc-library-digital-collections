# Generated via
#  `rails generate hyrax:work Course`

module Hyrax
  class CoursesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Course
    self.show_presenter = CourseShowPresenter
  end
end
