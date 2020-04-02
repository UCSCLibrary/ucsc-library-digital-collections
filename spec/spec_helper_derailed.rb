require 'capybara/rspec'
require 'selenium/webdriver'

#include Warden::Test::Helpers
Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium_headless

  host_url = ENV["HOST_URL"] || "http://localhost:3000"
  config.app_host = host_url
  
  host_parsed = URI.parse host_url
  config.server_host = host_parsed.host
  config.server_port = host_parsed.port
end
