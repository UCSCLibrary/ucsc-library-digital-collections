class CreateBmiLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_logs do |t|
      t.references :bmi_ingest, foreign_key: true
      t.references :bmi_row
      t.references :bmi_cell
      t.string :type
      t.string :subtype
      t.string :message

      t.timestamps
    end
  end
end
