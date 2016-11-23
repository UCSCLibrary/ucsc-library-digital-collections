class BmiIngestsController < ApplicationController
  before_action :set_bmi_ingest, only: [:show, :edit, :update, :destroy]

  # GET /bmi_ingests
  # GET /bmi_ingests.json
  def index
    @bmi_ingests = BmiIngest.all
  end

  # GET /bmi_ingests/1
  # GET /bmi_ingests/1.json
  def show
  end

  # GET /bmi_ingests/new
  def new
    @bmi_ingest = BmiIngest.new({:user_id => current_user.id})
  end

  # GET /bmi_ingests/1/edit
  def edit
  end

  # POST /bmi_ingests
  # POST /bmi_ingests.json
  def create
    @bmi_ingest = BmiIngest::create_new(bmi_ingest_params.merge(:user_id => current_user.id))
#    @bmi_ingest.setFile(bmi_ingest_params[:file])
    respond_to do |format|
      if @bmi_ingest.save
        format.html { redirect_to @bmi_ingest, notice: 'Batch metadata ingest was successfully created.' }
        format.json { render :show, status: :created, location: @bmi_ingest }
      else
        format.html {  redirect_to @bmi_ingest, error: 'Batch metadata ingest creation has failed. Contact Ned about this error.' }
        format.json { render json: @bmi_ingest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bmi_ingests/1
  # PATCH/PUT /bmi_ingests/1.json
  def update
    respond_to do |format|
      if @bmi_ingest.update(bmi_ingest_params)
        format.html { redirect_to @bmi_ingest, notice: 'Batch metadata ingest was successfully updated.' }
        format.json { render :show, status: :ok, location: @bmi_ingest }
      else
        format.html { render :edit }
        format.json { render json: @bmi_ingest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmi_ingests/1
  # DELETE /bmi_ingests/1.json
  def destroy
    @bmi_ingest.destroy
    respond_to do |format|
      format.html { redirect_to bmi_ingests_url, notice: 'Batch metadata ingest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bmi_ingest
      @bmi_ingest = BmiIngest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bmi_ingest_params
      params.require(:bmi_ingest).permit(:id,:user_id, :name, :file, :class_name, :identifier, :replace_files)

    end
end
