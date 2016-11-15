class AddReplaceFilesToBmiIngests < ActiveRecord::Migration[5.0]
  def change
    add_column :bmi_ingests, :replace_files, :boolean
  end
end
