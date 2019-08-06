module Ucsc
  module UntitledBehavior
    extend ActiveSupport::Concern
    
    def title
      if (normal_title = get_values(:title)).present?
        if (normal_title.first.downcase == "untitled") && (subseries = get_values(:subseries)).present?
          return ["Untitled: #{subseries.first}"]
        else
         return normal_title
        end
      end
      untitled_label = subseries.present? ? "Untitled: #{subseries.first}" : "Untitled"
      return UntitledArray.new(untitled_label)
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
