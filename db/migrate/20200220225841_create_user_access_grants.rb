class CreateUserAccessGrants < ActiveRecord::Migration[5.0]
  def change
    create_table :user_access_grants do |t|
      t.integer :user_id
      t.string :object_id
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
