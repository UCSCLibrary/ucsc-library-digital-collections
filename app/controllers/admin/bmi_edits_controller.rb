class Admin::BmiEditsController < ApplicationController
#  before_action :ensure_admin!
  layout 'admin'


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


  private

  def create_csv(ids)

  end

  def create_csv_header(ids)

  end

end
