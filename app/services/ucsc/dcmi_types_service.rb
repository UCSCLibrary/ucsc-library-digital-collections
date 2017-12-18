module Ucsc
  class DcmiTypesService < Hyrax::QaSelectService
    def initialize
      super('dcmi_types')
    end
  end
end
