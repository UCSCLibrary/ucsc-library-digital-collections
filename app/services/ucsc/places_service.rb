module Ucsc
  class PlacesService < Hyrax::QaSelectService
    def initialize
      super('ucsc_places')
    end
  end
end
