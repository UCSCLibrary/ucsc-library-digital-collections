class FixIngestWorkTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :bmi_ingests, :class_name, :work_type
  end
end
