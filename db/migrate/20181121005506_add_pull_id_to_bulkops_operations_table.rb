class AddPullIdToBulkopsOperationsTable < ActiveRecord::Migration[5.0]
  def change
    add_column :bulk_ops_operations, :pull_id, :integer
  end
end
