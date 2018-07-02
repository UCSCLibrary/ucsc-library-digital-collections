class PersistDerivatives < Hyrax::PersistDerivatives
  
  def self.derivative_path_factory
    ::DerivativePath
  end
  
end
