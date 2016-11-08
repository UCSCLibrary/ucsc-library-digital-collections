class FileSetsController < ApplicationController
  require 'digest'
  include CurationConcerns::FileSetsControllerBehavior
  include Sufia::Controller
  include Sufia::FileSetsControllerBehavior
  include HydraHls::FileSetsControllerBehavior  
end
