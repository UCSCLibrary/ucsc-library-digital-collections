class FixBmiRelationshipRowIdName < ActiveRecord::Migration[5.0]
  def change
    rename_column :bmi_relationships, :row_id, :bmi_row_id
  end
end
