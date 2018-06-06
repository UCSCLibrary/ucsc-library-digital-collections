module Ucsc
  module Workflow
    class ClaimObjectEdit

      def self.call(target:, user:, **)
        Claim.create!(work_id: target.id, user_id: user.id, type: "Edit")
      end

    end
  end
end
