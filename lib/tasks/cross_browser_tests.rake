desc "Use Sauce Labs to run acceptance tests in different browsers and environments"

task browser_tests: :environment do
  tests_config = YAML.load_file(File.join('/srv/hyrax','config',"test_environments.yml"))
  tests_config['platforms'].each do |platform_base_name, platform_config|
    (platform_config['versions'] || [nil]).each do |platform_version|
      platform_name = platform_base_name
      platform_name = "#{platform_name} #{platform_version}" if platform_version.present?
      platform_config['browsers'].each_with_index do |(browser_name, browser_config), i|
        browser_config ||= {}
        next unless (ENV['FULL_BROWSER_TESTS'] or browser_config["always"] or (i==0))
        next if browser_config['min_version'] && (browser_config['min_version'] > platform_version)
        next if browser_config['max_version'] && (browser_config['max_version'] < platform_version)

        versions = tests_config['browsers']['browser_name'].nil? ? ["latest"] : tests_config['browsers']['browser_name']['versions']
        versions.each do |browser_version|
          puts "SAUCE=true PLATFORM=\"#{platform_name}\" BROWSER=#{browser_name} BROWSER_VERSION=#{browser_version} SAUCE_USERNAME=#{ENV['SAUCE_USERNAME']} SAUCE_ACCESS_KEY=#{ENV['SAUCE_ACCESS_KEY']} ADMIN_PASSWORD=\"#{ENV['APP_ADMIN_PASSWORD']}\" bundle exec rspec spec/acceptance"
          break unless ENV['FULL_BROWSER_TESTS']
        end
      end
      break unless ENV['FULL_BROWSER_TESTS']
    end
  end
end
