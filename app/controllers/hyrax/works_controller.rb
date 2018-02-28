require 'ucsc/breadcrumbs_for_works'
module Hyrax
  class WorksController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Ucsc::BreadcrumbsForWorks

    self.curation_concern_type = ::Work
    self.show_presenter = Ucsc::WorkShowPresenter
  end
end
