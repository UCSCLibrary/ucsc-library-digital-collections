class UpdateBmiIngests < ActiveRecord::Migration[5.0]
  def change
    rename_column :bmi_ingests, :identifier, :edit_identifier
    add_column :bmi_ingests, :relationship_identifier, :string
    add_column :bmi_ingests, :visibility, :boolean
    add_column :bmi_ingests, :notifications, :boolean
  end
end
