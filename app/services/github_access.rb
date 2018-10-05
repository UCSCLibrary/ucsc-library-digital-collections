require "octokit"
require "socket"
require "securerandom"
require 'base64'

class GithubAccess



  #
  #
  #
  #
  #
  # This is for OAUTH, which isn't working...yet
  #
  #
  #
  #  def self.auth_url user
  #    "#{Octokit.web_endpoint}login/oauth/authorize?client_id=#{client_id}&redirect_url=#{redirect_endpoint(user)}&state=#{state(user)}&scope=repo"
  #  end
  #
  #  def self.valid_state?(astate,user=nil)
  #    user = current_user if user.nil?
  #    astate === state(user)
  #  end
  #
  #  def self.state user=nil
  #    user = current_user if user.nil?
  #    if (cred = GithubCredential.find_by(user_id: user.id))
  #      cred.state
  #    else
  #      cred = GithubCredential.create({user_id: user.id, state: SecureRandom.hex })
  #      cred.state
  #    end
  #  end
  #
  #  def self.auth_token user=nil
  #    user = current_user if user.nil?
  #    return false unless (cred = GithubCredential.find_by(user_id: user.id))
  #    return false unless (token = cred.auth_code)
  #    token
  #  end
  #
  #  def self.set_auth_token!(token,user=nil)
  #    user = current_user if user.nil?
  #    cred = GithubCredential.find_by(user_id: user.id)
  #    cred.auth_code = token
  #    cred.save
  #  end
  #
  #  def self.client_id
  #    YAML.load_file("#{Rails.root.to_s}/config/github.yml")[Rails.env]["client_id"]
  #  end
  #
  #  def self.client_secret
  #    YAML.load_file("#{Rails.root.to_s}/config/github.yml")[Rails.env]["client_secret"]
  #  end
  #
  #  def self.redirect_endpoint user
  #    "https://#{Socket.gethostname}/github_auth/#{User.first.id}"
  #  end
  #
  #
  #
  #
  #
  #

  def self.create_branch branch_name, work_ids = []
    client.create_ref repo, "heads/#{branch_name}", master_sha
  end

  def self.add_file branch_name, file_path, file_name = nil, message=false
    file_name ||= File.basename file_path
    message ||= "adding file #{file_name} to github branch #{branch_name}"
    client.create_contents(repo, file_name, message, file: path, branch: branch_name)
  end

  def self.add_contents branch_name, file_name, contents, message=false
    message ||= "adding file #{file_name} to github branch #{branch_name}"
    client.create_contents(repo, template_file_name, message, Base64.encode64(contents), branch: branch_name)
  end

  def self.list_branches
    client.branches(repo)
  end

  def self.get_file_contents branch_name, filename
    Base64.decode64( client.contents(repo, path: filename,branch: branch_name) )
  end

  private

  def self.repo
    github_config["repo"]
  end

  def self.master_sha
    client.branch(repo,"master").commit.sha
  end

  def self.client
    @client ||= Octokit::Client.new(login: 'ethenry@ucsc.edu', password: 'hmAae301')
  end

  def self.github_config
    @github_config ||=  YAML.load_file("#{Rails.root.to_s}/config/github.yml")[Rails.env]
  end

  

end
