module Ucsc
  class TopicsService < Hyrax::QaSelectService
    def initialize
      super('ucsc_topics')
    end
  end
end
