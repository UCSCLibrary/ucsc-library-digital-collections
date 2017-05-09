class BmiRowsController < ApplicationController

  load_and_authorize_resource

  def row_info
    respond_to do |format|
      format.html{
        render :row_details, :layout => false      
      }
      format.json {
        render json: @bmi_row.info
      }
    end
  end
end
