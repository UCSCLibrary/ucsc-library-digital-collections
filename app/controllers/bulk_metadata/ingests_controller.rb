class BulkMetadata::IngestsController < ApplicationController
#  before_action :ensure_admin!
  layout 'dashboard'
  load_and_authorize_resource

  # GET /ingests
  # GET /ingests.json
  def index
    @ingests = BulkMetadata::Ingest.all
  end

  # GET /ingests/1
  # GET /ingests/1.json
  def show
  end

  # GET /ingests/new
  def new
    @ingest = BulkMetadata::Ingest.new({:user_id => current_user.id})
  end

  # GET /ingests/1/edit
  def edit
  end

  def ingest_all
    @ingest.rows.where(:status => "parsed").each do |row|
      row.ingest! current_user.email
    end
    respond_to do |format|
      format.html {  redirect_to @ingest, notice: 'Ingests initiated.' }
    end
  end

  def process_row
    case params['process-action']
        when 'parse'
          #THIS IS A DUMMY METHOD THAT ONLY 
          # MARKS THEM AS PARSED WITHOUT DOING ANYTHING!!
          params['row-id'].each do |id|
            row = BulkMetadata::Row.find(id)
#            row.createNewCells!(row.text)
            row.status="parsed"
            row.save
          end

        when 'ingest'
          params['row-id'].each do |id|
            row = BulkMetadata::Row.find(id)
            row.ingest! current_user.email
          end
        when 'export-csv'
          export_csv
          return          
        when 'remove'
# TODO write this (delete row and delete item if ingested)
          
    end

    respond_to do |format|    
      format.html {  redirect_to @ingest, notice: "Bulk "+params['process-action']+" completed"}
    end
  end

  def export_csv
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
        render :text => @ingest.get_csv(params['row-id'])
      end
      format.html do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=test.csv'    
        render :text => @ingest.get_csv(params['row-id'])
      end
    end
  end

  def row_info
    @row = BulkMetadata::Row.find(params[:row_id])
    render :row_details, :layout => false      
  end

  # POST /ingests
  # POST /ingests.json
  def create
    
    @ingest = BulkMetadata::Ingest::create_new(ingest_params.merge(:user_id => current_user.id))

    respond_to do |format|
      unless @ingest.save
        format.html {  redirect_to @ingest, error: 'Batch metadata ingest creation has failed. Contact Ned about this error.' }
        format.json { render json: @ingest.errors, status: :unprocessable_entity }
      end

      if @ingest.hasSpecLine?
        format.html { redirect_to @ingest, notice: 'Batch metadata ingest was successfully created.' }
        format.json { render :show, status: :created, location: @ingest }
      else
      format.html { redirect_to @ingest, notice: 'Batch metadata ingest was successfully created.' }
      format.json { render :edit, status: :created, location: @ingest }       
      end
    end
  rescue NameError => exception
    handle_parse_error exception
  end

  # PATCH/PUT /ingests/1
  # PATCH/PUT /ingests/1.json
  def update
    respond_to do |format|
      if @ingest.update(ingest_params)
        format.html { redirect_to @ingest, notice: 'Batch metadata ingest was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingest }
      else
        format.html { render :edit }
        format.json { render json: @ingest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ingests/1
  # DELETE /ingests/1.json
  def destroy
    @ingest.destroy
    respond_to do |format|
      format.html { redirect_to ingests_url, notice: 'Batch metadata ingest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def info
    render json: @ingest.get_basic_info(params[:type])
  end


  def handle_parse_error(exception)
    logger.error("Error parsing ingest: #{exception.inspect}")
    flash[:error] = 'Error parsing csv file: '+exception.to_s
    redirect_to action: "index"
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def ingest_params
      params.require(:bulk_metadata_ingest).permit(:id,:user_id, :name, :file, :work_type, :identifier, :replace_files)
    end
end
