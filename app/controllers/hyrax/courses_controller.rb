require 'ucsc/breadcrumbs_for_works'
module Hyrax
  class CoursesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Course
    self.show_presenter = CourseShowPresenter
  end
end
