require 'coveralls'
Coveralls.wear!('rails')

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

case ENV['BRANCH']
when "staging"
  host_suffix = "-staging"
when "sandbox"
  host_suffix = "-staging-sandbox"
else
  host_suffix = ""
end
target_hostname = "digitalcollections#{host_suffix}.library.ucsc.edu"

if (user = ENV['STAGING_USERNAME']).present? and (pass = ENV['STAGING_PASSWORD']).present?
  host_url = "https://#{user}:#{pass}@#{target_hostname}"
else
  host_url = "https://#{target_hostname}"
end
host_parsed = URI.parse "https://#{target_hostname}"

Capybara.configure do |config|
  config.run_server = false
  config.app_host = host_url
  config.server_host = host_parsed.host
  config.server_port = host_parsed.port
end

Capybara.app_host = host_url
Selenium::Webdriver::Firefox::Binary.path="/usr/bin/firefox"
