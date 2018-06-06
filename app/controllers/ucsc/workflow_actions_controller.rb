module Ucsc
  class WorkflowActionsController < Hyrax::WorkflowActionsController

    def update
      return super if params['ids'].blank?
      errors = []
      params['ids'].each do |id|
        form = Hyrax::Forms::WorkflowActionForm.new(
          current_ability: current_ability,
          work: ActiveFedora::Base.find(id),
          attributes: {workflow_action: 'approve'})
        unless form.save
          errors << id
        end
      end

#      if errors.blank?
      redirect_to '/admin/workflows', notice: "The states of your works have been updated. #{errors.to_s} - #{params.to_s}"
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
end

