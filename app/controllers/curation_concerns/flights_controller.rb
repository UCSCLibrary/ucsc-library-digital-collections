# Generated via
#  `rails generate curation_concerns:work Flight`

module Hyrax
  class FlightsController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = Flight
  end
end
