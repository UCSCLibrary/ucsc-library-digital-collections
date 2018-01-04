class BulkMetadata::Cell < ApplicationRecord
  self.table_name = "bmi_cells"
  belongs_to :row
end
