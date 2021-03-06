module Ucsc
  module Forms
    class CollectionForm < Hyrax::Forms::CollectionForm
      self.model_class = ::Collection
      
      include ScoobySnacks::WorkFormBehavior

      self.terms.each do |term|
        delegate term, to: :model
      end

    end
  end
end
