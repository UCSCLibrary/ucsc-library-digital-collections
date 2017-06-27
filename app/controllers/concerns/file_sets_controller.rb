class FileSetsController < ApplicationController
  require 'digest'
  include Hyrax::FileSetsControllerBehavior
  include Hyrax::Controller
  include Hyrax::FileSetsControllerBehavior
  include SamveraHls::FileSetsControllerBehavior  
end
