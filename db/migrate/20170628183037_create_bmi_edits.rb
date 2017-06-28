class CreateBmiEdits < ActiveRecord::Migration[5.0]
  def change
    create_table :bmi_edits do |t|
      t.text :work_ids
      t.string :status
      t.string :user
      t.date :deadline
      t.text :comment
      t.integer :workflow_id
      t.integer :workflow_action_id

      t.timestamps
    end
  end
end
