class RecordsController < ApplicationController
  include Hydra::Controller::ControllerBehavior

  def show
    record = SolrDocument.find(params[:id])
    if record.human_readable_type == "Collection"
      url = "/collections/#{record.id}"
    else
      url = "/concern/#{record.human_readable_type.downcase.pluralize}/#{record.id}"
    end
    redirect_to url, status: 301
  end

end
