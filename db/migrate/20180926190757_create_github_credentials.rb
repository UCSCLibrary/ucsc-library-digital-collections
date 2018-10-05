class CreateGithubCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :github_credentials do |t|
      t.integer :user_id
      t.string :username
      t.string :oauth_code
      t.string :state

      t.timestamps
    end
    add_index :github_credentials, :user_id
  end
end
