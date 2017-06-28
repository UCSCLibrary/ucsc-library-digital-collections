class Admin::BmiEditsController < ApplicationController
  before_action :set_bmi_edit, only: [:show, :edit, :update, :destroy]

  layout 'admin'

  # GET /bmi_edits
  # GET /bmi_edits.json
  def index
    @bmi_edits = Admin::BmiEdit.all
  end

  # GET /bmi_edits/1
  # GET /bmi_edits/1.json
  def show
  end

  # GET /bmi_edits/new
  def new
    @bmi_edit = Admin::BmiEdit.new
  end

  # GET /bmi_edits/1/edit
  def edit
  end

  # POST /bmi_edits/export
  # POST /bmi_edits/export.csv
  def export
    @bmi_edit = Admin::BmiEdit.find(params['batch_edit_id'])
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=batch_edit.csv'    
        render :text => @bmi_edit.get_csv(params['ids'])
      end
      format.html do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
        render :text => @bmi_edit.get_csv(params['ids'])
      end
    end
  end

  # POST /bmi_edits
  # POST /bmi_edits.json
  def create
    @bmi_edit = Admin::BmiEdit.new(bmi_edit_params)

    respond_to do |format|
      if @bmi_edit.save
        format.html { redirect_to @bmi_edit, notice: 'Bmi edit was successfully created.' }
        format.json { render :show, status: :created, location: @bmi_edit }
      else
        format.html { render :new }
        format.json { render json: @bmi_edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bmi_edits/1
  # PATCH/PUT /bmi_edits/1.json
  def update
    respond_to do |format|
      if @bmi_edit.update(bmi_edit_params)
        format.html { redirect_to @bmi_edit, notice: 'Bmi edit was successfully updated.' }
        format.json { render :show, status: :ok, location: @bmi_edit }
      else
        format.html { render :edit }
        format.json { render json: @bmi_edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmi_edits/1
  # DELETE /bmi_edits/1.json
  def destroy
    @bmi_edit.destroy
    respond_to do |format|
      format.html { redirect_to bmi_edits_url, notice: 'Bmi edit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bmi_edit
      @bmi_edit = Admin::BmiEdit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bmi_edit_params
      params.require(:bmi_edit).permit(:work_ids, :status, :user, :deadline, :comment, :workflow_id, :workflow_action_id)
    end
end
