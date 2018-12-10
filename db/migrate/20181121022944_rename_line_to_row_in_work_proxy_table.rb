class RenameLineToRowInWorkProxyTable < ActiveRecord::Migration[5.0]
  def change

    rename_column :bulk_ops_work_proxys, :line_number, :row_number
  end
end
