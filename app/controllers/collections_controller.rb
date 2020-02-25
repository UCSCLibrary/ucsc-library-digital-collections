class CollectionsController < Hyrax::CollectionsController
  self.presenter_class = Ucsc::CollectionPresenter
end
