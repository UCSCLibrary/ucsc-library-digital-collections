class Admin::WorkflowActionsController < Hyrax::WorkflowActionsController

  def update
    return super if params['ids'].blank?
    errors = []
    action = Sipity::WorkflowAction.where(name: params["workflow_action"], workflow_id: params["workflow_id"]).first!
    params['ids'].each do |id|
      subject = Hyrax::WorkflowActionInfo.new(work, user)
      Hyrax::Workflow::WorkflowActionService.run(subject: subject, action: action)
    end

     redirect_to '/admin/workflows', notice: "The states of your works have been updated."
 
  end
  
  def workflow_action_params
    #      @workflow_action_params ||= params.require(:workflow_action).permit(:name, :comment)
    params
  end

end

