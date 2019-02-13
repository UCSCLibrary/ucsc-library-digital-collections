json.extract! github_credential, :id, :user_id, :username, :oauth_code, :created_at, :updated_at
json.url github_credential_url(github_credential, format: :json)
