# Presents a list of works in workflow
class Admin::WorkflowsController < Hyrax::Admin::WorkflowsController

  class_attribute :workflow
  class_attribute :claimed_states

  self.workflow = Sipity::Workflow.last
  self.claimed_states = ["under_review","changes_underway"]

  def index

    @states = []
    @workflow_id = workflow.id

    workflow.workflow_states.each do |state|
      label = state.name.titleize
      if claimed_states.include? state.name
        list = Workflow::Claim.where(user_id: current_user.id, sipity_workflow_states_id: state.id )
      else
        list = Hyrax::Workflow::StatusListService.new(self, "workflow_state_name_ssim:#{state.name}")
      end
      
      actions = Sipity::WorkflowStateAction.where(originating_workflow_state_id: state.id).map{|sa| sa.workflow_action}
      
      @states << {label: label,
                  name: state.name,
                  id: state.id,
                  list: list,
                  actions: actions}

    end
  end
end
