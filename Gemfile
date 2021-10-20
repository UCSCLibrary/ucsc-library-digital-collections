source 'https://rubygems.org'

ruby '2.7.2'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '= 5.2.4.5'

# This gem allows a mysql relational database for activerecord, etc
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use the jquery JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Active-fedora connects the fcrepo repository to our rails app
gem 'active-fedora'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use Puma as the app server
  gem 'puma'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# This is the main application engine
# We are keeping up with Hyrax 2.x, and waiting to upgrade to Hyrax 3
gem 'hyrax', '~> 2.9.0'

# This gem creates a quick solr instance for testing purposes
# We use docker instead nowadays, so this is now disabled.
#group :development, :test do
#  gem 'solr_wrapper', '>= 0.3'
#end

# rsolr helps our app interface with Solr
gem 'rsolr', '~> 1.0'

# Devise handles users and authentication
gem "devise", ">= 4.7.1"
gem 'devise-guests', '~> 0.5'


group :development, :test do
  # rspec is our main testing framework
  gem 'rspec-rails', :require => false
  # factory_bot helps rspec create test resources
  gem 'factory_bot_rails', :require => false
  # this gem helps emulate web requests to test controller classes
  gem 'rails-controller-testing'
  # Capybara lets tests emulate a browser to test the whole application
  gem 'capybara'
  # Selenium runs the browser part of Capybara
  gem 'selenium-webdriver'
  # Webdrivers allows rails to interface with browsers
  gem 'webdrivers'
  # Capistrano is used to deploy new code automatically
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger', '>= 0.1.1'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end

# hydra-role-management allows devise users to be assigned to roles in Hyrax
#  and granted permissions based on these roles
gem 'hydra-role-management'
# browse-everything allows file imports from cloud platforms. We haven't used
# it in ages, but it might be useful in some cases.
gem 'browse-everything'
#gem 'hydra-remote_identifier'

# Samvera_hls handles audiovisual streaming using Http Live Streaming
# Uncomment the following line when developing samvera_hls to load the gem from a local folder
#gem 'samvera_hls', path: "/srv/samvera_hls/"
# This loads the samvera_hls gem from RubyGems
gem 'samvera_hls', '0.4.4'

# ScoobySnacks configures our metadata schema for us
# Uncomment the following line when developing scooby snacks to load the gem from a local folder
#gem 'scooby_snacks', path: '/srv/scooby_snacks/'
# The following line loads the most recent ScoobySnacks version from github
gem 'scooby_snacks', git: 'git://github.com/UCSCLibrary/ScoobySnacks.git'

# BulkOps handles bulk ingests and updates
# Uncomment the following line when developing Bulk Ops to load the gem from a local folder
#gem 'bulk_ops', path: "/srv/bulk_ops/"
# The following line loads the most recent ScoobySnacks version from github
gem 'bulk_ops', git: 'git://github.com/UCSCLibrary/BulkOps.git', branch: 'master'

gem 'sinatra', git: 'git://github.com/sinatra/sinatra.git'

# The following three gems handle the interface for monitoring background tasks
gem 'resque-pool'
gem 'sidekiq'
gem 'capistrano-sidekiq', git: 'git://github.com/seuros/capistrano-sidekiq.git'
'git://github.com/libgit2/rugged.git'


gem 'blacklight_advanced_search', '~> 6.0'
gem 'blacklight_oai_provider', '>= 6.0.0'

# riiif is a iiif server built into rails.
# We no longer need this because of our image server,
# but you can un-comment this to restore it if necessary.
#gem 'riiif', '~> 1.1'

gem "octokit", "~> 4.0"

gem 'actionview', '>= 5.0.7.2'

gem 'bundler', '>= 2'

# Coveralls is a cloud service that monitors our app's test coverage
gem 'coveralls', require: false

# Mini-magick is a ruby interface for imagemagick
gem "mini_magick", ">= 4.9.4"

gem 'rubyzip'
