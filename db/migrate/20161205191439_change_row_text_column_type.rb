class ChangeRowTextColumnType < ActiveRecord::Migration[5.0]
  def change
    remove_column :bmi_rows, :text, :string
    add_column :bmi_rows, :text, :text
    remove_column :bmi_cells, :value_string, :string
    add_column :bmi_cells, :value_string, :text
  end
end
