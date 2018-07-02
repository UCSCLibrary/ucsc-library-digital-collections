class CreateSipityClaims < ActiveRecord::Migration[5.0]
  def change
    create_table :sipity_claims do |t|
      t.integer :work_id
      t.references :user, foreign_key: true
      t.string :type

      t.timestamps
    end
    add_index :sipity_claims, :work_id
  end
end
