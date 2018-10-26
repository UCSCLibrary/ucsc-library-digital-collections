require "octokit"
require "socket"
require "securerandom"
require 'base64'

class BulkOps::GithubAccess

  ROW_OFFSET = 2

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

  attr_accessor :name

  def self.create_branch! name
    self.new(name).create_branch!
  end

  def self.add_file name, file_path, file_name = nil, message=false
    self.new(name).add_file file_path, file_name = nil, message=false
  end

  def self.add_contents name, file_name, contents, message=false
    self.new(name).add_contents file_name, contents, message=false
  end

  def self.update_options name, options, message=false
    self.new(name).update_options options, message=false
  end

  def self.list_branches
    self.new("dummy").list_branches
  end

  def initialize(name)
    @name = name
  end

  def create_branch!
    client.create_ref repo, "heads/#{name}", current_master_commit_sha
  end

  def add_file file_path, file_name = nil, message=false
    file_name ||= File.basename file_path
    message ||= "adding file #{file_name} to github branch #{name}"
    client.create_contents(repo, file_name, message, file: path, branch: name)
  end


  def add_contents file_name, contents, message=false
    message ||= "adding file #{file_name} to github branch #{name}"
    client.create_contents(repo, template_file_name, message, Base64.encode64(contents), branch: name)
  end

  def list_branches
    client.branches(repo)
  end

  def update_spreadsheet filename, message=false
    message ||= "updating metadata spreadsheet through hyrax browser interface. User: #{current_user.email}"
    sha = Digest::SHA1.hexdigest(client.contents(repo,spreadsheet_filename))
    client.update_contents(repo, spreadsheet_filename, message, sha, file: filename)
  end

  def update_options options, message=false
    message ||= "updating metadata spreadsheet through hyrax browser interface. User: #{current_user.email}"
    sha = Digest::SHA1.hexdigest(client.contents(repo,options_filename))
    client.update_contents(repo, options_filename, message, sha, YAML.dump(options))
  end


  def load_options 
    YAML.load(get_file_contents(options_filename))
  end

  def load_metadata
    CSV.parse(get_file_contents(spreadsheet_filename), headers: true)
  end

  def log_ingest_event log_level, row_number, event_type, message, commit_sha = nil
    commit_sha ||= current_branch_commit_sha
    #TODO WRITE THIS CODE
  end

  def get_metadata_row row_number
    @current_metadata ||= load_metadata
    @current_metadata[row_number - ROW_OFFSET]
  end
  
  def get_past_metadata_row commit_sha, row_number
    past_metadata = Base64.decode64( client.contents(repo, path: filename, ref: commit_sha) )
    past_metadata[row_number - ROW_OFFSET]
  end

  def self.get_file_contents name, filename
    Base64.decode64( client.contents(repo, path: filename, ref: name) )
  end

  private

  def repo
    github_config["repo"]
  end

  def current_master_commit_sha
    client.branch(repo,"master").commit.sha
  end

  def current_branch_commit_sha
    client.branch(repo, name).commit.sha
  end

  def client
    @client ||= Octokit::Client.new(login: github_config["user"], password: github_config["password"])
  end

  def github_config
    @github_config ||=  YAML.load_file("#{Rails.root.to_s}/config/github.yml")[Rails.env]
  end

  def spreadsheet_filename
    "#{name}/metadata.csv"
  end
  def options_filename
    "#{name}/configuration.yml"
  end

end
