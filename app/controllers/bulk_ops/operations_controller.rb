class BulkOps::OperationsController < ApplicationController

  before_action :ensure_admin!
  before_action :initialize_options, only: [:new,:show,:edit]
  before_action :initialize_operation, only: [:edit, :delete, :show, :apply, :request_application, :csv, :errors, :log]
  layout 'dashboard'
  attr_accessor :git

  def index
    @active_operations = BulkOps.Operation.where.not(stage: ['completed','discarded'])
    @old_operations = BulkOps.Operation.where(stage: ['completed','discarded']) if params["show_old_ops"]
  end

  def new
    if params["create_operation"]

      # Create a unique operation name if the chosen name is taken
      op_name = params['name']  
      while  BulkOps::Operation.find_by(name: op_name) do
        if ['-','_'].include?(op_name[-2]) && op_name[-1].to_i > 0
          op_name = op_name[0..-2]+(op_name[-1].to_i + 1).to_s
        else
          op_name = op_name + "_1"
        end
      end

      operation = BulkOps::Operation.create(name: params['name'], status: "new", stage: "new", operation_type: params['type'], message: "This #{params['type']} is brand new, just created", user: current_user)

      operation.create_branch fields: params['fields'],  options: updated_options

      operation.status = "OK"

      case params['type']
      when "ingest"
        operation.stage = "pending"
        operation.message = "Generated blank ingest spreadsheet and created Github branch for this ingest"
      when "update"
        operation.stage = "draft"
        operation.message = "New update draft created. Ready for admins to select which works to edit."
      end

      operation.status = "OK"
      operation.save

      #redirect to operation show page
      redirect_to action: "show", id: operation.id, notice: "Bulk #{params['type']} created successfully"
    end
    
  end

  def show
    if @operation.running?
      @num_works = @operation.work_proxys.count
      @num_queued = @operation.work_proxys.where(status: 'queued').count
      @num_running = @operation.work_proxys.where(status: 'running').count
      @num_failed = @operation.work_proxys.where(status: 'failed').count
      @num_complete = @operation.work_proxys.where(status: 'complete').count
      @num_other = @operation.work_proxys.where.not(status: ['queued','running','failed','complete']).count
    end
  end

  def edit
    if params['add-work-id'] && @operation.draft?
      added = false
      params['add-work-id'].each do |work_id|
        unless BulkOps::WorkProxy.find_by(operation_id: @operation.id, work_id: work_id)
          BulkOps::WorkProxy.create(operation_id: @operation.id, 
                                    work_id: work_id,
                                    status: "new",
                                    last_event: DateTime.now
                                    message: "Works added to future update by #{current_user.name || current_user.email}")
          added = true
        end
      end
      flash[:notice] = "Works added successfully to update" if added
    end

    destroyed = false
    if params['remove-work-id'] && @operation.draft?
      params['remove-work-id'].each do |work_id|
        if (proxy = BulkOps::WorkProxy.find_by(work_id: work_id))
          proxy.destroy!
          destroyed = true
        end
      end
      flash[:notice] = "Works removed successfully from update" if destroyed
    end

    #if a new spreadsheet is uploaded, update them in github
    if params['spreadsheet'] && @operation.name
      @operation.update_spreadsheet params['spreadsheet']
    end

    #If new options have been defined, update them in github
    if params["options"] && @operation.name
      options = @operation.options
      params["options"].each do |option_name, option_value|
        options[options_name] = option_value
      end
      BulkOps::GithubAccess.update_options(@operation.name, options)
    end  

    redirect_to action: "show", id: @operation.id
  end

  def search
    @collection = Collection.find(params["collection_id"]) if params["collection_id"]
    @admin_set = AdminSet.find(params["admin_set_id"]) if params["admin_set_id"]
    @workflow_state = Sipity::WorkflowState.find(params["workflow_state_id"]) if params["workflow_state_id"]

    start = params['start'] || 0
    rows = params['rows'] || 10

    builder = BulkOps::SearchBuilder.new(scope: self,
                                         collection: @collection,
                                         admin_set: @admin_set,
                                         workflow_state: @workflow_state,
                                         keyword_query: @query).rows(rows)
    @results = repostiory.search(builder).documents

    response.headers['Content-Type'] = 'application/json'
    render json: {num_results: results.count, results: results[start,rows]}
  end


  def delete
    @operation.destroy!
    flash[:notice] = "Bulk #{@operation.type} deleted successfully"
    redirect_to action: "index"
  end

  def request_application
    #create pull request for operation branch
    #do verification steps on options and spreadsheet formatting
    #
    #once authorization is working, this should check if the logged in user can auto-authorize
  end
  
  def apply
    #verify that branch is merged (which ought to trigger this action)

    #do actual operations
    @operation.apply
  end

#  def preview
    #implement this someday
#  end


  def csv
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
    render :text => @operation.get_spreadsheet
  end

  def info
    #render json with operation info
  end

  def errors
    #render json with recent error messages
  end

  def log
    #render json with recent log messages
  end


  private

  def updated_options
    available_options = ['notifications','type','file_method','creator_email']
    params.select{|key, value| available_options.include?(key)}
  end

  def initialize_options
    @file_update_options = [["Update metadata only. Do not change files in any way.",'metadata-only'],
                            ["Remove all files attached to these works and ingest a new set of files",'replace-all'],
                            ["Re-ingest some files with replacements of the same filename. Leave other files alone.","reingest-some"],
                            ["Remove one list of files and ingest another list of files. Leave other files alone.","remove-and-add"]]
    default_notifications = [current_user,User.first]
    @notified_users = params['notified_user'].blank? ? default_notifications : params['notified_user'].map{ |user_id| User.find(user_id.to_i)}
  end

  def initialize_operation
    #define branch options if a branch is not specified
    if (id = params["operation_id"]) || (id = params["id"])
      @operation = BulkOps::Operation.find(id)
    elsif params["operation_name"]
      @operation = BulkOps::Operation.find_by(name: params["operation_name"])
    end
    if @operation.nil?
      @branches = BulkOps::GithubAccess.list_branches
      @branch_options = @branches.map{|branch| [branch[:name],branch[:name]]} - [['master','master']]
      @branch_options = [["No Bulk Updates Defined",0]] if @branch_options.blank?
    elsif @operation.stage == "draft" 
      @works = @operation.work_proxys.map{|work_proxy| SolrDocument.find(work_proxy.work_id)}
      @collections = Collection.all.map{|col| [col.title.first,col.id]}
      @admin_sets = AdminSet.all.map{|aset| [aset.title.first, aset.id]}
      workflow = Sipity::Workflow.where(name:"ucsc_generic_ingest").last
      @workflow_states = workflow.workflow_states.map{|st| [st.name, st.id]}
    end
  end
  
  #TODO
  def ensure_admin!
    # Do appropriate user authorization for this. Based on workflow roles / privileges? Or just user roles?
  end

end
