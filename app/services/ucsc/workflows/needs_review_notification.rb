module Ucsc
  module Workflow
    class NeedsReviewNotification < Hyrax::Workflow::PendingReviewNotification
      
      def subject
        "New record(s) ready for review"
      end

      def message
        "#{title} (#{link_to work_id, document_path}) is ready for review. #{comment}"
      end

    end
  end
end
