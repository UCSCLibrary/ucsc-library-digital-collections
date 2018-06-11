module Workflow
  class UnclaimObjectEdit

    def self.call(target:, user:, **)
      Claim.where(work_id: target.id, user_id: user.id, type: "Edit").each{|claim| 
        claim.destroy!
      }
    end

  end
end
