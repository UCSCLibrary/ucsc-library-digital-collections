class CollectionsController < Hyrax::CollectionsController
  layout :resolve_layout
  self.presenter_class = Ucsc::CollectionPresenter
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
  
end
