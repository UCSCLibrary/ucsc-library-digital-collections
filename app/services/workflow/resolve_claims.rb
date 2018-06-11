module Workflow
  class ResolveClaims

    def self.call(target:, user:, **)
      Claim.where(work_id: target.id, user_id: user.id).each{|claim| 
        claim.destroy!
      }
    end

  end
end
