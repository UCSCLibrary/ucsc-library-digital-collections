class CollectionsController < Hyrax::CollectionsController
  layout :resolve_layout
  self.presenter_class = Ucsc::CollectionPresenter

  def resolve_layout
    query_collection_members
    return "collection_with_subcollections" if @subcollection_count > 0
    "hyrax"
  end
  
end
