class ChangeBulkMetaCellColumns < ActiveRecord::Migration[5.0]
  def change
    rename_table :bmi_cells, :bulk_meta_cells
    rename_table :bmi_rows, :bulk_meta_rows
    rename_table :bmi_ingests, :bulk_meta_ingests
    rename_table :bmi_logs, :bulk_meta_logs
    rename_table :bmi_relationships, :bulk_meta_relationships

    change_table :bulk_meta_cells do |t|
      t.rename :value_string, :value
    end
  end
end
