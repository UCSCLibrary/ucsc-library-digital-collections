class ChangeWorkIdToStringInWorkflowClaims < ActiveRecord::Migration[5.0]
  def change

    remove_column :sipity_claims, :work_id
    add_column :sipity_claims, :work_id, :string

  end
end
