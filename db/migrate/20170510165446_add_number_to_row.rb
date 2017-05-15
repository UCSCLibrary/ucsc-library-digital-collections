class AddNumberToRow < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_rows, :line_number, :integer
  end
end
