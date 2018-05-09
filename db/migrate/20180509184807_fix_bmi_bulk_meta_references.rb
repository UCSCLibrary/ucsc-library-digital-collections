class FixBmiBulkMetaReferences < ActiveRecord::Migration[5.0]
  def change
#    drop_table :bmi_edits
#    remove_foreign_key :bulk_meta_logs, column: :bmi_ingest_id
#    remove_foreign_key :bulk_meta_logs, column: :bmi_row_id
#    remove_foreign_key :bulk_meta_logs, column: :bmi_cell_id
#    remove_foreign_key :bulk_meta_relationships, column: :bmi_row_id
#    remove_foreign_key :bulk_meta_cells, column: :bmi_row_id
#    remove_foreign_key :bulk_meta_rows, column: :bmi_ingest_id

#    rename_column :bulk_meta_logs, :bmi_ingest_id, :ingest_id
#    rename_column :bulk_meta_logs, :bmi_row_id, :row_id
#    rename_column :bulk_meta_logs, :bmi_cell_id, :cell_id
#    rename_column :bulk_meta_relationships, :bmi_row_id, :row_id
#    rename_column :bulk_meta_cells, :bmi_row_id, :row_id
#    rename_column :bulk_meta_rows, :bmi_ingest_id, :ingest_id

    add_foreign_key :bulk_meta_logs, :bulk_meta_ingests, column: :ingest_id
    add_foreign_key :bulk_meta_logs, :bulk_meta_rows, column: :row_id
    add_foreign_key :bulk_meta_logs, :bulk_meta_cells, column: :cell_id
    add_foreign_key :bulk_meta_relationships, :bulk_meta_rows, column: :row_id
    add_foreign_key :bulk_meta_cells, :bulk_meta_rows, column: :row_id
    add_foreign_key :bulk_meta_rows, :bulk_meta_ingests, column: :ingest_id

  end
end
