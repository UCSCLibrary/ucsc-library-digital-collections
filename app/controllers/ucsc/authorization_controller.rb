class Ucsc::AuthorizationController < ApplicationController

  def authorize
    doc = ::SolrDocument.find(params[:id])
    if current_ability.can?(:read, doc)
      render plain: "Access Granted", status: :ok
    else
      render plain: "FORBIDDEN", status: :unauthorized
    end
  end

end
