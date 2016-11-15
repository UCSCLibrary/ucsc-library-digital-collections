class CreateBmiIngests < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_ingests do |t|
      t.references :user, foreign_key: true
      t.string :filename
      t.string :class
      t.string :status

      t.timestamps
    end
  end
end
