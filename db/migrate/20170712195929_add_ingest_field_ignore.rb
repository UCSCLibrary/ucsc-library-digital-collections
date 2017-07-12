class AddIngestFieldIgnore < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_ingests, :ignore, :string
  end
end
