require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UcscHyrax
  class Application < Rails::Application
    
    config.generators do |g|
      g.test_framework :rspec, :spec => true
    end

    config.autoload_paths += %W(#{config.root}/app/presenters)
    config.autoload_paths += %W(#{config.root}/lib)

    config.tinymce.install = :copy

    config.to_prepare do
      Hyrax::FileSetsController.prepend SamveraHls::FileSetsControllerBehavior  
    end

    config.active_job.queue_adapter = :sidekiq

    # After rails bumped to 5.2.8.1 YAML only loads classes from a permitted white list
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::HashWithIndifferentAccess]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
