class RenameBmiToBulkMetadata < ActiveRecord::Migration[5.0]

  def change
    rename_table :bmi_rows, :bulk_meta_rows
    rename_table :bmi_ingests, :bulk_meta_ingests
    rename_table :bmi_cells, :bulk_meta_cells
    rename_table :bmi_relationships, :bulk_meta_relationships
    rename_table :bmi_logs, :bulk_meta_logs
    drop_table :bmi_edits

    change_table :bulk_meta_rows do |t|
      t.rename(:bmi_ingest_id, :ingest_id) 
    end
    change_table :bulk_meta_cells do |t|
      t.rename(:bmi_row_id, :row_id) 
    end
    change_table :bulk_meta_relationships do |t|
      t.rename(:bmi_row_id, :row_id) 
    end
    change_table :bulk_meta_logs do |t|
      t.rename(:bmi_row_id, :row_id) 
      t.rename(:bmi_ingest_id, :ingest_id) 
      t.rename(:bmi_cell_id, :cell_id) 
    end

  end

end
