# Be sure to restart your server when you modify this file.

domain = %w[production staging sandbox n8_staging].include?(Rails.env) ? ENV.fetch('SITE_DOMAIN', '.library.ucsc.edu') : :all
Rails.application.config.session_store :cookie_store, key: '_ucsc_hyrax_session', domain: domain
