require 'sauce_whisk'

Capybara.default_max_wait_time = 10

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  config.before do |test|
    Capybara.register_driver :sauce do |app|

      opt = platform(test.full_description)
      caps = Selenium::WebDriver::Remote::Capabilities.send(opt.delete(:browser_name).to_sym, opt)

      url = 'https://ondemand.saucelabs.com:443/wd/hub'
      Capybara::Selenium::Driver.new(app,
                                     browser: :remote,
                                     url: url,
                                     desired_capabilities: caps)
    end
    Capybara.current_driver = :sauce
  end

  config.after do |test|
    session_id = Capybara.current_session.driver.browser.session_id
    SauceWhisk::Jobs.change_status(session_id, !test.exception)
    Capybara.current_session.quit
  end

  def platform(name)
    { platform_name: ENV['PLATFORM'].capitalize.gsub(/[-_]/,' ') || "macOS 10.14",
      browser_name: ENV['BROWSER'] || "firefox",
      browser_version: ENV['BROWSER_VERSION'] || 'latest'}.merge(sauce_w3c(name))
    
  end

  def sauce_w3c(name)
    {'sauce:options' => {name: name,
                         build: build_name,
                         username: ENV['SAUCE_USERNAME'],
                         access_key: ENV['SAUCE_ACCESS_KEY'],
                         iedriver_version: '3.141.59',
                         selenium_version: '3.141.59'}}
  end

  #
  # Note that this build name is specifically for Travis CI execution
  #
  def build_name
    if ENV['GIT_BRANCH']
      "#{ENV['GIT_BRANCH'][%r{[^/]+$}]}: #{ENV['GIT_COMMIT']}"
    elsif ENV['SAUCE_START_TIME']
      ENV['SAUCE_START_TIME']
    else
      "Ruby-RSpec-Capybara: Local-#{Time.now.to_i}"
    end
  end
  
end
