class Admin::WorkflowActionsController < Hyrax::WorkflowActionsController

  def update
    return super if params['ids'].blank?
    errors = []
#    action = Sipity::WorkflowAction.where(name: params["workflow_action"], workflow_id: params["workflow_id"]).first
    params['ids'].each do |id|
      form = Hyrax::Forms::WorkflowActionForm.new(
        current_ability: current_ability,
        work: ActiveFedora::Base.find(id),
        attributes: {name: params["workflow_action"]})
      unless form.save
        errors << id
      end
    end

    #      if errors.blank?
    redirect_to '/admin/workflows', notice: "The states of your works have been updated. id: #{errors.first.to_s}    actionid:  #{action.id}"
    #      else
    #        Rails.logger.error("error updating works: #{errors.join(', ')}")
    #        puts "error updating works: #{errors.join(', ')}"
    #        render 'hyrax/base/unauthorized', status: :unauthorized
    #      end

  end
  
  def workflow_action_params
    #      @workflow_action_params ||= params.require(:workflow_action).permit(:name, :comment)
    params
  end

end

