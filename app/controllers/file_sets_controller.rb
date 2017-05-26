
#class FileSetsController < Hyrax::FileSetsController
class FileSetsController 
  skip_before_action :authenticate_user!, :only => [:show,:citation, :stats,  :embed, :master, :variant]
  skip_authorize_resource :only => [:show,:citation, :stats,  :embed, :master, :variant]
  include HydraHls::FileSetsControllerBehavior  
end
