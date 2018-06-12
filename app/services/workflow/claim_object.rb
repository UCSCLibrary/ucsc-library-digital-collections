module Workflow
  class ClaimObject

    def self.call(target:, user:, **)
      workflow_state = Sipity::Entity.find_by(proxy_for_global_id: target.to_global_id.to_s).workflow_state
      Claim.create!(work_id: target.id, user_id: user.id, sipity_workflow_states_id: workflow_state.id)
    end

  end
end

