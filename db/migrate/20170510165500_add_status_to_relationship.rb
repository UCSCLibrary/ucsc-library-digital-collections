class AddStatusToRelationship < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_relationships, :status, :string
  end
end
