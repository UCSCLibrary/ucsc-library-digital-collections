# Presents a list of works in workflow
class Admin::WorkflowsController < Hyrax::Admin::WorkflowsController

  class_attribute :workflow
  class_attribute :claimed_states

  self.workflow = Sipity::Workflow.last
  self.claimed_states = ["review_underway","changes_underway"]

  def index

    states = []
    @workflow_id = workflow.id

    workflow.workflow_states.each do |state|
      label = state.name.titleize
      if claimed_states.include? state.name
        
        list = Workflow::Claim.where(user_id: current_user.id, sipity_workflow_states_id: state.id ).map{|claim| SolrDocument.find(claim.work_id)}
      else
        list = Hyrax::Workflow::StatusListService.new(self, "workflow_state_name_ssim:#{state.name}")
      end
      
      actions = Sipity::WorkflowStateAction.where(originating_workflow_state_id: state.id).map{|sa| sa.workflow_action}

      states << {label: label,
                  name: state.name,
                  id: state.id,
                  list: list,
                  actions: actions,
                  order: preferred_order(state.name)}
    end
    @states = states.sort_by{|state| state[:order]}
  end


  def preferred_order state_name
    case state_name
    when "review_required"
      return 1
    when "review_underway"
      return 2
    when "changes_required"
      return 3
    when "changes_underway"
      return 4
    when "complete"
      return 5
    else
      return 10
    end
    
end
