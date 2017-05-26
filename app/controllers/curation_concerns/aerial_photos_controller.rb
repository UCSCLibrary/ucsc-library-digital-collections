# Generated via
#  `rails generate curation_concerns:work AerialPhoto`

module Hyrax
  class AerialPhotosController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = AerialPhoto
  end
end
