include Blacklight::Facet
class CollectionsController < Hyrax::CollectionsController
  #layout :resolve_layout
  self.presenter_class = Ucsc::CollectionPresenter
  skip_load_and_authorize_resource :only => :show_all
  load_and_authorize_resource except: [:index, :create], instance_name: :collection

  def resolve_layout
    return "hyrax" if action_name == "show_all"
    query_collection_members
    return "collection_with_subcollections" if @subcollection_count > 0
    "hyrax"
  end

  # This makes the search box on a collection page lead back to the same collection page
  # instead of the search results page
  def search_action_url options = {}
    url_for(options.reverse_merge(action: 'index', controller: 'catalog').deep_merge(f: {"ancestor_collection_titles_ssim" => Array(@collection.title)}))
  end
  def show_all
    builder = Ucsc::CollectionSearchBuilder.new(self).with(params.except(:q))
    @response = repository.search(builder)
    @collections = @response.documents.select{ |col| ["open","campus"].include?(col.visibility)}
    rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
      []
    end
    

    def facet
      @facet = blacklight_config.facet_fields[params[:id]]
      raise ActionController::RoutingError, 'Not Found' unless @facet
      @response = get_facet_field_response(@facet.key, params)
      @display_facet = @response.aggregations[@facet.field]
      @pagination = facet_paginator(@facet, @display_facet)
      respond_to do |format|
        format.html do
          # Draw the partial for the "more" facet modal window:
          return render layout: false if request.xhr?
          # Otherwise draw the facet selector for users who have javascript disabled.
        end
        format.json
      end
    end
end
