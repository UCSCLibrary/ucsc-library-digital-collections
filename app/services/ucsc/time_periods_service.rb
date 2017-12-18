module Ucsc
  class TimePeriodsService < Hyrax::QaSelectService
    def initialize
      super('ucsc_time_periods')
    end
  end
end
