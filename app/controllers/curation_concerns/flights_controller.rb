# Generated via
#  `rails generate curation_concerns:work Flight`

module CurationConcerns
  class FlightsController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = Flight
  end
end
