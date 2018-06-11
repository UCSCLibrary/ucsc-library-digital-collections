class ChangeTypeColumnToWorkflowStateInSipityClaims < ActiveRecord::Migration[5.0]
  def change
    remove_column :sipity_claims, :type
    add_reference :sipity_claims, :sipity_workflow_states, index: true


  end
end
