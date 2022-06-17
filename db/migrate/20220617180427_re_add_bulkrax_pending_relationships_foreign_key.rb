class ReAddBulkraxPendingRelationshipsForeignKey < ActiveRecord::Migration[5.2]
  def change
    if foreign_key_exists?(:bulkrax_pending_relationships, :bulkrax_importer_runs)
      remove_foreign_key :bulkrax_pending_relationships, :bulkrax_importer_runs
      add_foreign_key :bulkrax_pending_relationships, :bulkrax_importer_runs, column: :importer_run_id
    end
  end
end
