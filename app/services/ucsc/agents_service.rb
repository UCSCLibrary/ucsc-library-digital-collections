module Ucsc
  class AgentsService < Hyrax::QaSelectService
    def initialize
      super('ucsc_agents')
    end
  end
end
