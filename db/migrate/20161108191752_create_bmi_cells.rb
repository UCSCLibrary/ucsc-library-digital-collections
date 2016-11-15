class CreateBmiCells < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_cells do |t|
      t.references :bmi_row, foreign_key: true
      t.string :name
      t.string :value_string
      t.string :value_url
      t.integer :status

      t.timestamps
    end
  end
end
