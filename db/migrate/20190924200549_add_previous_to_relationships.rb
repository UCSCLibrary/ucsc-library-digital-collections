class AddPreviousToRelationships < ActiveRecord::Migration[5.0]
  def change
    add_column :bulk_ops_relationships, :previous_sibling, :string
  end
end
