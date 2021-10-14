module Ucsc
  module Dashboard
    class CollectionsController < Hyrax::Dashboard::CollectionsController
      self.form_class = Hyrax::Forms::CollectionForm
    end
  end
end
