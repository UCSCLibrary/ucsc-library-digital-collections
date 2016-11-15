class AddIdentifierToBmiIngests < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_ingests, :identifier, :string
  end
end
