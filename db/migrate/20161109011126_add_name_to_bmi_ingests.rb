class AddNameToBmiIngests < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_ingests, :name, :string
  end
end
