module Ucsc
  module Dashboard
    class CollectionsController < Hyrax::Dashboard::CollectionsController
      self.form_class = Ucsc::Forms::CollectionForm
    end
  end
end
