class BulkOps::WorkProxy < ApplicationRecord
  self.table_name = "bulk_ops_work_proxys"
  belongs_to :operation, class_name: "BulkOps::Operation"
end
