class ChangeBulkMetaCellColumns < ActiveRecord::Migration[5.0]
  def change
    change_table :bulk_meta_cells do |t|
      t.rename :value_string, :value
    end
  end
end
