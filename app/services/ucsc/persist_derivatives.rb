module Ucsc
  class PersistDerivatives < Hyrax::PersistDerivatives
    
    def self.derivative_path_factory
      Ucsc::DerivativePath
    end
    
  end
end
