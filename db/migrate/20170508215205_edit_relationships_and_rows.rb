class EditRelationshipsAndRows < ActiveRecord::Migration[5.0]
  def change

    add_column :bmi_rows, :ingested_id, :string
    remove_column :bmi_relationships, :subject_id
    add_column :bmi_relationships, :row_id, :integer

  end
end
