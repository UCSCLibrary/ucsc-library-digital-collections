# Generated via
#  `rails generate curation_concerns:work Work`

module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior

    self.curation_concern_type = Work
  end
end
