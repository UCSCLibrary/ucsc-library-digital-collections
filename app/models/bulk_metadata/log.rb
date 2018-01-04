class BulkMetadata::Log < ApplicationRecord
  self.table_name = "bmi_logs"

  belongs_to :ingest
  belongs_to :row  
  belongs_to :cell
end
