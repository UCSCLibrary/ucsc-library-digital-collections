class RenameGithubCredentialsTable < ActiveRecord::Migration[5.0]
  def change
    rename_table :github_credentials :bulk_ops_github_credentails
  end
end
