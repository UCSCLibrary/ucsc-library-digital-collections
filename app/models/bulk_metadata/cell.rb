class BulkMetadata::Cell < ApplicationRecord
  self.table_name = "bulk_meta_cells"
  belongs_to :row
end
