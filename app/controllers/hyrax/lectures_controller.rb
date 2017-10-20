# Generated via
#  `rails generate hyrax:work Lecture`

module Hyrax
  class LecturesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Lecture
    self.show_presenter = LectureShowPresenter
  end
end
