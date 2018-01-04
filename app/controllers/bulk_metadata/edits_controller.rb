class BulkMetadata::EditsController < ApplicationController
  before_action :set_edit, only: [:show, :edit, :update, :destroy]

  load_and_authorize_resource

  layout 'dashboard'

  # GET /bulk_metadata/edits
  # GET /bulk_metadata/edits.json
  def index
    @edits = BulkMetadata::Edit.all
  end

  # GET /bulk_metadata/edits/1
  # GET /bulk_metadata/edits/1.json
  def show
  end

  # GET /bulk_metadata/edits/new
  def new
    @edit = BulkMetadata::Edit.new
  end

  # GET /bulk_metadata/edits/1/edit
  def edit
  end

  # POST /bulk_metadata/edits/export
  # POST /bulk_metadata/edits/export.csv
  def export
#    @edit = Edit.find(params['batch_edit_id'])
    respond_to do |format|
      format.csv {csv_response}
      format.html {csv_response}
    end
  end

  def csv_response
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=batch_edits_#{@edit.id}.csv"    
    render :text => @edit.export_csv(current_user,params['ids'])
  end

  # POST /bulkmetadata/edits
  # POST /bulkmetadata/edits.json
  def create
    @edit = Edit.new(edit_params)

    respond_to do |format|
      if @edit.save
        format.html { redirect_to @edit, notice: 'Bulk edit was successfully created.' }
        format.json { render :show, status: :created, location: @edit }
      else
        format.html { render :new }
        format.json { render json: @edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_metadata/edits/1
  # PATCH/PUT /bulk_metadata/edits/1.json
  def update
    respond_to do |format|
      if @edit.update(edit_params)
        format.html { redirect_to @edit, notice: 'Bulk edit was successfully updated.' }
        format.json { render :show, status: :ok, location: @edit }
      else
        format.html { render :edit }
        format.json { render json: @edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_metadata/edits/1
  # DELETE /bulk_metadata/edits/1.json
  def destroy
    @edit.destroy
    respond_to do |format|
      format.html { redirect_to edits_url, notice: 'Bulk edit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edit
      @edit = Edit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edit_params
      params.require(:edit).permit(:work_ids, :status, :user, :deadline, :comment, :workflow_id, :workflow_action_id)
    end
end
