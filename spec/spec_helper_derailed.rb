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

  if (username = ENV['STAGING_USERNAME']).present? && (password = ENV['STAGING_PASSWORD']).present? && !Rails.env.production?
    host_url = "https://#{username}:#{password}@#{Rails.config.hostname}"
  else
    host_url = "https://#{Rails.config.hostname}"
  end
  config.app_host = host_url
  host_parsed = URI.parse host_url
  config.server_host = host_parsed.host
  config.server_port = host_parsed.port
end
