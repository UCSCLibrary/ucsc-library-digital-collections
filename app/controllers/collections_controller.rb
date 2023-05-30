class CollectionsController < Hyrax::CollectionsController
  layout :resolve_layout
  self.presenter_class = Ucsc::CollectionPresenter
  skip_load_and_authorize_resource :only => :index
  load_and_authorize_resource except: [:index, :create], instance_name: :collection

  # Limit facets and per page results on A-Z
  before_action only: :index do
    self.blacklight_config.facet_fields.slice!('creator_sim', 'subjectName_sim', 'subjectPlace_sim', 'subjectTopic_sim')
    self.blacklight_config.default_per_page = 10
  end
  # Restore defaults for collection landing page, remove 'collection' facet
  before_action only: :show do
    self.class.copy_blacklight_config_from(::CatalogController)
    # Sort the works by title only for Aerials photographs collection
    if @collection.title.first == "UC Santa Cruz Aerial Photographs Collection" && params[:q].blank? && params[:cq].blank? && params[:f].blank?
      sort_fields = self.blacklight_config.sort_fields["score desc, system_create_dtsi desc"]
      sort_fields["sort"] = "title_ssi asc"
    end
    
    # hide collection facet when searching within one collection
    self.blacklight_config.facet_fields.delete('ancestor_collection_titles_ssim')
  end

  def resolve_layout
    return "hyrax" if action_name == "index"
    query_collection_members
    return "collection_with_subcollections" if @subcollection_count > 0
    "hyrax"
  end

  # Use collections controller for facet links
  def search_action_url options = {}
    if action_name == "index"
      url_for(options.reverse_merge(action: "index", controller: 'collections'))
    elsif action_name == "show"
      # Using collections#show, if a facet value is clicked that comes from a member work
      # the search fails and goes to homepage with a not authorized error.
      # Using catalog#index the facets work, but its independent of keyword searching.
      url_for(options.reverse_merge(action: 'index', controller: 'catalog').deep_merge(f: {"ancestor_collection_titles_ssim" => Array(@collection.title)}))
    else
      super
    end
  end

  def index
    builder = Ucsc::CollectionSearchBuilder.new(self).with(params)
    @response = repository.search(builder)
    @collections = @response.documents.select{ |col| ["open","campus"].include?(col.visibility)}
    @presenter = presenter_class.new(current_ability, @collections)
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    []
  end

end
