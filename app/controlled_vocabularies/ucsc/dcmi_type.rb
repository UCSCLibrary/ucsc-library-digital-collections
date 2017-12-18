module Ucsc
  module ControlledVocabularies
    class DcmiType < Ucsc::ControlledVocabularies::Resource
      configure rdf_label: ::RDF::Vocab::DC.MediaType
    end
  end
end
