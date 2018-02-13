# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    
    include ScoobySnacks::WorkFormBehavior

    self.terms.each do |term|
      delegate term, to: :model
    end

  end
end
