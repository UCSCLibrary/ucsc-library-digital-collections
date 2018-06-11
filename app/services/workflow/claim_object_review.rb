module Workflow
  class ClaimObjectReview

    def self.call(target:, user:, **)
      Claim.create!(work_id: target.id, user_id: user.id, type: "Review")
    end

  end
end
