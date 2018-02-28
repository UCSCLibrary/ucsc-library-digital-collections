class RecordsController < ApplicationController
  include Hydra::Controller::ControllerBehavior

  def show
    record = ActiveFedora::Base.find(params[:id])
    if record.class.to_s == "Collection"
      url = "/collections/#{record.id}"
    else
      url = "/concern/#{record.class.to_s.downcase.pluralize}/#{record.id}"
    end
    redirect_to url, status: 301
  end

end