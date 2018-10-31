class ReplaceBulkUpdateTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :bulk_update_inclusions
    drop_table :bulk_update_drafts

    create_table :bulk_ops_operations do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false, unique: true
      t.string :stage, null: false
      t.string :operation_type
      t.string :commit_sha
      t.string :status
      t.text :message
      t.timestamps
    end

    create_table :bulk_ops_work_proxys do |t|
      t.integer :operation_id
      t.string :work_id
      t.integer :line_number
      t.datetime :last_event
      t.string :status
      t.text :message
      t.timestamps
    end
    add_reference :bulk_ops_work_proxys, :operation_id, index: true
    add_foreign_key :bulk_ops_work_proxys, :bulk_ops_operations, column: :operation_id

    create_table :bulk_ops_relationships do |t|
      t.references :work_proxy
      t.string   :object_identifier
      t.string   :identifier_type
      t.string   :relationship_type
      t.string   :status
      t.timestamps
    end
    add_reference :bulk_ops_relationships, :work_proxy_id, index: true
    add_foreign_key :bulk_ops_relationships, :bulk_ops_work_proxys, column: :work_proxy_id

  end
end
