module Ucsc
  module UntitledBehavior
    extend ActiveSupport::Concern
    
    def title
      return attributes["title"] if attributes["title"].present?
      solr_array = to_solr
      untitled_label = solr_array[ solr_array.keys.detect{|key| key.include? "titleDisplay"} ].first
      UntitledArray.new(untitled_label)
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
