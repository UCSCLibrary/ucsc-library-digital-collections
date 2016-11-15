# Generated via
#  `rails generate curation_concerns:work AerialPhoto`

module CurationConcerns
  class AerialPhotosController < ApplicationController
    include CurationConcerns::CurationConcernController
    # Adds Sufia behaviors to the controller.
    include Sufia::WorksControllerBehavior

    self.curation_concern_type = AerialPhoto
  end
end
