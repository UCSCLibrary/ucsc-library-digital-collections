class CreateBmiRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_relationships do |t|
      t.string :subject_id
      t.string :object_identifier
      t.string :identifier_type
      t.string :relationship_type

      t.timestamps
    end
  end
end
