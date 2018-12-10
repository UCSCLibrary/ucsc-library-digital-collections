class FixBulkOpsWorkProxysTable < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :bulk_ops_work_proxys, :bulk_ops_operations
    remove_foreign_key :bulk_ops_relationships, :bulk_ops_work_proxys
    drop_table :bulk_ops_work_proxies
    
    create_table :bulk_ops_work_proxies do |t|
      t.integer :operation_id
      t.string :work_id
      t.integer :row_number
      t.datetime :last_event
      t.string :status
      t.text :message
      t.timestamps
    end

  end
end
