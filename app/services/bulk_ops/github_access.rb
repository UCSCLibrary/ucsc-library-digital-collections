require "octokit"
require "socket"
require "securerandom"
require 'base64'

class BulkOps::GithubAccess

  ROW_OFFSET = 2
  SPREADSHEET_FILENAME = 'metadata.csv'
  OPTIONS_FILENAME = 'configuration.yml'

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

  def self.load_options name
    self.new(name).load_options
  end

  def self.load_metadata branch: name, return_headers: false
    self.new(name).load_metadata return_headers: return_headers
  end
  
  def self.update_options name, options, message=false
    self.new(name).update_options options, message=false
  end

  def self.list_branches
    self.new("dummy").list_branches
  end

  def self.list_branch_names
    self.new("dummy").list_branch_names
  end

  def initialize(name)
    @name = name.parameterize
  end

  def create_branch!
    client.create_ref repo, "heads/#{name}", current_master_commit_sha
  end

  def delete_branch!
    return false unless list_branch_names.include? name
    client.delete_branch repo, name
  end

  def add_file file_path, file_name = nil, message=nil
    file_name ||= File.basename(file_path)
#    unless (file_name.downcase == "readme.md") || (file_name.downcase.include? "#{name}/")
    file_name = File.join name, file_name unless file_name.downcase.include? "#{name}/"
    message ||= "adding file #{file_name} to github branch #{name}"
    client.create_contents(repo, file_name, message, file: file_path, branch: name)
  end

  def add_contents file_name, contents, message=false
    message ||= "adding file #{file_name} to github branch #{name}"
    client.create_contents(repo, file_name, message, contents, branch: name)
  end

  def add_new_spreadsheet file_contents, message=false
    add_contents(spreadsheet_path, file_contents, message)
  end

  def list_branches
    client.branches(repo).select{|branch| branch[:name] != "master"}
  end

  def list_branch_names
    list_branches.map{|branch| branch[:name]}
  end

  def update_spreadsheet file, message=false
    message ||= "updating metadata spreadsheet through hyrax browser interface."
    
    sha = get_file_sha(spreadsheet_path)
    client.update_contents(repo, spreadsheet_path, message, sha, file.read, branch: name)
  end

  def update_options options, message=false
    message ||= "updating metadata spreadsheet through hyrax browser interface."
    sha = get_file_sha(options_path)
    client.update_contents(repo, options_path, message, sha, YAML.dump(options), branch: name)
  end

  def load_options 
    YAML.load(Base64.decode64(get_file_contents(options_path)))
  end

  def load_metadata branch: nil, return_headers: false
    branch ||= name
    CSV.parse(Base64.decode64(get_file_contents(spreadsheet_path, branch)), {headers: true, return_headers: return_headers})
  end

  def log_ingest_event log_level, row_number, event_type, message, commit_sha = nil
    commit_sha ||= current_branch_commit_sha
    #TODO WRITE THIS CODE
  end

  def create_pull_request
    begin
      pull = client.create_pull_request(repo, "master", name, "Apply update #{name} through Hyrax browser interface", "In Hyrax, an administrator has requested to apply a bulk update represented by this Git branch.")
      pull["number"]
    rescue Octokit::UnprocessableEntity
      return false
    end
  end

  def can_merge?
    return true
  end

  def merge_pull_request pull_id
    client.merge_pull_request(repo, pull_id)
  end

  def get_metadata_row row_number
    @current_metadata ||= load_metadata
    @current_metadata[row_number - ROW_OFFSET]
  end
  
  def get_past_metadata_row commit_sha, row_number
    past_metadata = Base64.decode64( client.contents(repo, path: filename, ref: commit_sha) )
    past_metadata[row_number - ROW_OFFSET]
  end

  def get_file filename
    client.contents(repo, path: filename, ref: name)
  end

  def get_file_contents filename, ref=nil
    ref ||= name
    client.contents(repo, path: filename, ref: ref)[:content]
  end

  def get_file_sha filename
    client.contents(repo, path: filename, ref: name)[:sha]
  end

  def repo
    github_config["repo"]
  end

  def spreadsheet_path
    "#{name}/#{SPREADSHEET_FILENAME}"
  end

  private

  def options_path
    "#{name}/#{OPTIONS_FILENAME}"
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


end
