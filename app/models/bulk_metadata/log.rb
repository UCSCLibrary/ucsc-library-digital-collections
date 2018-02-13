class BulkMetadata::Log < ApplicationRecord
  self.table_name = "bulk_meta_logs"

  belongs_to :ingest
  belongs_to :row  
  belongs_to :cell
end
