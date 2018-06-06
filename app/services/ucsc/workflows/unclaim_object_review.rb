module Ucsc
  module Workflow
    class UnclaimObjectReview

      def self.call(target:, user:, **)
        Claim.where(work_id: target.id, user_id: user.id, type: "Review").each{|claim| 
          claim.destroy!
        }
      end

    end
  end
end
