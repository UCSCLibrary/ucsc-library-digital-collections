class CreateBmiRows < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_rows do |t|
      t.references :bmi_ingest, foreign_key: true
      t.string :status
      t.string :text

      t.timestamps
    end
  end
end
