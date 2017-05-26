# Generated via
#  `rails generate curation_concerns:work Lecture`

module Hyrax
  class LecturesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = Lecture
    self.show_presenter = LectureShowPresenter
  end
end
