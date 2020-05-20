require 'capybara'
require 'capybara/rspec'
require 'selenium/webdriver'

if ENV['SAUCE'] || ENV['SAUCE_USERNAME']
  require 'sauce_spec_helper'
else
  #include Warden::Test::Helpers
  Capybara.configure do |config|
    config.default_driver = :selenium_headless
  end
end

Capybara.configure do |config|
  config.run_server = false
  case ENV['BRANCH_NAME']
  when "staging"
    host_suffix = "-staging"
  when "sandbox"
    host_suffix = "-staging-sandbox"
  else
    host_suffix = ""
  end
  target_hostname = "digitalcollections#{host_suffix}.library.ucsc.edu"
      
  unless (user = ENV['STAGING_USERNAME']).nil? or (pass = ENV['STAGING_PASSWORD']).nil? or (ENV['RAILS_ENV'] == 'production')
    host_url = "https://#{user}:#{pass}@target_hostname"
  else
    host_url = "https://#{ENV['TARGET_HOSTNAME']}"
  end
  config.app_host = host_url
  host_parsed = URI.parse "https://#{ENV['TARGET_HOSTNAME']}"
  config.server_host = host_parsed.host
  config.server_port = host_parsed.port
end
