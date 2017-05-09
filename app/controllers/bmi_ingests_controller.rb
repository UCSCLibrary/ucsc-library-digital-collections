class BmiIngestsController < ApplicationController
#class BmiIngestsController 
  load_and_authorize_resource

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

  def ingest_all
    @bmi_ingest.bmi_rows.where(:status => "parsed").each do |row|
      row.ingest!
    end
    respond_to do |format|
      format.html {  redirect_to @bmi_ingest, notice: 'Ingests initiated.' }
    end
  end

  def process_row
    case params['process-action']
        when 'parse'
          #THIS IS A DUMMY METHOD THAT ONLY 
          # MARKS THEM AS PARSED WITHOUT DOING ANYTHING!!
          params['row-id'].each do |id|
            row = BmiRow.find(id)
#            row.createNewCells!(row.text)
            row.status="parsed"
            row.save
          end

        when 'ingest'
          params['row-id'].each do |id|
            row = BmiRow.find(id)
            row.ingest! current_user
          end
        when 'export-csv'
          
        when 'remove'
    end

    respond_to do |format|    
      format.html {  redirect_to @bmi_ingest, notice: 'Action Processed: '+params['row-id'].first }
    end
  end

  def export_csv
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
        render :text => @bmi_ingest.get_csv(params['rows'])
      end
      format.html do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
        render :text => @bmi_ingest.get_csv(params['rows'])
      end
    end
  end

  def row_info
    @row = BmiRow.find(params[:row_id])
    render :row_details, :layout => false      
  end

  # POST /bmi_ingests
  # POST /bmi_ingests.json
  def create
    #error handling here
    @bmi_ingest = BmiIngest::create_new(bmi_ingest_params.merge(:user_id => current_user.id))

#    @bmi_ingest.setFile(bmi_ingest_params[:file])
    respond_to do |format|
      unless @bmi_ingest.save
        format.html {  redirect_to @bmi_ingest, error: 'Batch metadata ingest creation has failed. Contact Ned about this error.' }
        format.json { render json: @bmi_ingest.errors, status: :unprocessable_entity }
      end

      if @bmi_ingest.hasSpecLine?
        format.html { redirect_to @bmi_ingest, notice: 'Batch metadata ingest was successfully created.' }
        format.json { render :show, status: :created, location: @bmi_ingest }
      else
      format.html { redirect_to edit_bmi_ingest_path(@bmi_ingest), notice: 'Batch metadata ingest was successfully created.' }
      format.json { render :edit, status: :created, location: @bmi_ingest }       
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

  def info
    render json: @bmi_ingest.get_basic_info(params[:type])
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def bmi_ingest_params
      params.require(:bmi_ingest).permit(:id,:user_id, :name, :file, :class_name, :identifier, :replace_files)
    end
end
