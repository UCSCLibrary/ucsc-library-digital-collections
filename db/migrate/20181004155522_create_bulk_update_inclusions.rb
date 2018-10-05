class CreateBulkUpdateInclusions < ActiveRecord::Migration[5.0]
  def change
    create_table :bulk_update_inclusions do |t|
      t.string :work_id
      t.references :bulk_update_draft, foreign_key: true

      t.timestamps
    end
  end
end
