module Ucsc
  module ControlledVocabularies
    class Topic < Ucsc::ControlledVocabularies::Resource
      configure rdf_label: ::RDF::Vocab::DC.subject
    end
  end
end
