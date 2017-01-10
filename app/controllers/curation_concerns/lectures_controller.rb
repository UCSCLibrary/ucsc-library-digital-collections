# Generated via
#  `rails generate curation_concerns:work Lecture`

module CurationConcerns
  class LecturesController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = Lecture
    self.show_presenter = LectureShowPresenter
  end
end
