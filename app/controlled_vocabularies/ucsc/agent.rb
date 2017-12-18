module Ucsc
  module ControlledVocabularies
    class Agent < Ucsc::ControlledVocabularies::Resource
      configure rdf_label: ::RDF::Vocab::DC.Agent
    end
  end
end
