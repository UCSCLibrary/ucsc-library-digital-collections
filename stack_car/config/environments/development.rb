Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = !!Sidekiq.server?
  
  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # SMTP Mailer configuration
  # Add SMTP settings to your environment and uncomment the following section to enable mailer
  # if ENV['SMTP_ENABLED'].present? && ENV['SMTP_ENABLED'].to_s == 'true'
  #   config.action_mailer.smtp_settings = {
  #     user_name: ENV['SMTP_USER_NAME'],
  #     password: ENV['SMTP_PASSWORD'],
  #     address: ENV['SMTP_ADDRESS'],
  #     domain: ENV['SMTP_DOMAIN'],
  #     port: ENV['SMTP_PORT'],
  #     enable_starttls_auto: true,
  #     authentication: ENV['SMTP_TYPE']
  #   }
  #    # ActionMailer Config
  #   config.action_mailer.delivery_method = :smtp
  #   config.action_mailer.perform_deliveries = true
  #   config.action_mailer.raise_delivery_errors = false
  
  # else
  #   config.action_mailer.delivery_method = :test
  # end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.action_mailer.default_url_options = { host: "localhost:3001" }

  config.web_console.whitelisted_ips = ['172.18.0.0/16', '172.27.0.0/16', '0.0.0.0/0']

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_job.queue_adapter     = Settings.active_job.queue_adapter
  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
