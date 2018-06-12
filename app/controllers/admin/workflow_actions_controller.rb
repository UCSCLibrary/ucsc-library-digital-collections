class Admin::WorkflowActionsController < Hyrax::WorkflowActionsController

  def update
    return super if params['ids'].blank?
    errors = []
    action = Sipity::WorkflowAction.where(name: params["workflow_action"], workflow_id: params["workflow_id"]).first!
    params['ids'].each do |id|
      subject = Hyrax::WorkflowActionInfo.new(ActiveFedora::Base.find(id), current_user)
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: action)
    end
     redirect_to '/admin/workflows', notice: "The states of your works have been updated."
  end

end

