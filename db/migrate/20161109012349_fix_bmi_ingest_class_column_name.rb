class FixBmiIngestClassColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :bmi_ingests, :class, :class_name
  end
end
