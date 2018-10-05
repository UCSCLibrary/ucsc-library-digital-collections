class BulkUpdatesController < ApplicationController

  before_action :ensure_admin!
  before_action :fetch_info, only: [:show, :edit, :delete, :apply, :csv, :preview]
  layout 'dashboard'

  def index
    #fetch list of updates and their info from github
#    @updates = 
    
  end

  def new
    unless BulkUpdateDraft.find_by(name: "Default", user_id: current_user.id)
      BulkUpdateDraft.create(name:"Default", user_id: current_user.id)
    end
    @group_name_options = BulkUpdateDraft.all.map{|group| [group.name, group.id]}
    @group_id = params['group_id'] || "1"
    @group_name = BulkUpdateDraft.find(@group_id).name
    
  end

  def edit
    
  end

  def update
    
  end

  def delete
  end

  def apply
  end

  def csv
  end

  def preview
  end

  def export_csv
  end

  def running
  end

  def errors
  end

  def log
  end

  def status
  end

  private
  
  #TODO
  def fetch_info
    #pull anything from github that we need
  end

  #TODO
  def ensure_admin!
    # Do appropriate user authorization for this. Based on workflow roles / privileges? Or just user roles?
  end

end
