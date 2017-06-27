class Admin::BmiRowsController < ApplicationController
#  before_action :ensure_admin!
  layout 'admin'

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
