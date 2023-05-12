# Enable locale fallbacks for I18n (makes lookups for any locale fall back to
# the I18n.default_locale when a translation cannot be found).
Rails.application.config.i18n.fallbacks = true
Rails.application.config.i18n.available_locales = [:en]
Rails.application.config.i18n.default_locale = :'en'
Rails.application.config.i18n.enforce_available_locales = true
