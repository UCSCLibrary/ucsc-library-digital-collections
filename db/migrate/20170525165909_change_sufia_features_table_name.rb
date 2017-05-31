class ChangeSufiaFeaturesTableName < ActiveRecord::Migration[5.0]
  def self.up
    rename_table :sufia_features, :hyrax_features
  end

  def self.down
    rename_table :bar, :foo
  end
end
