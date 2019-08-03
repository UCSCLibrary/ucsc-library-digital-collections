module Ucsc
  module UntitledBehavior
    extend ActiveSupport::Concern
    
    def title
      if (title = get_values(:title))
        return title
      else
        untitled_label = "Untitled"
        untitled_label = "Untitled: #{subseries.first}" if subseries.present?
        return UntitledArray.new(untitled_label)
      end
    end

    class UntitledArray < Array

      def initialize(untitled_label)
        @untitled_label = untitled_label
        super()
      end

      def first
        @untitled_label
      end

      def join(separator)
        @untitled_label
      end

      def to_s
        @untitled_label
      end

    end
    
  end
end
