ruby "2.0.0"
source "https://rubygems.org"
github_auth = '1c67c24746803ca24c170bea972e37c97877c0a0:x-oauth-basic'
gem 'rails', '~> 4.0.0'

# Servers and environment
gem 'dotenv-rails'
gem 'settingslogic'

# Javascript
gem 'gon'
gem 'rack-pjax'

# For operations
gem 'health_check'

# For calling APIs, response parsing etc.
gem 'service_api', git: "https://#{github_auth}@github.com/westfield/service_api.git"
gem 'faraday'
gem 'faraday_middleware'
gem 'service_helper', git: "https://#{github_auth}@github.com/westfield/service_helper.git"
gem 'hashie'
gem 'cloudinary'
gem 'sitemap_generator'
gem 'sterile'
gem 'parallel'

# Caching
gem 'redis-rails'

# To support ?nocache=xxxx hack
gem 'request_store'

# Presentation, pagination etc.
gem 'kaminari'
gem 'money'
gem 'truncate'
gem 'draper', '~> 1.3'

gem 'splunk_logger', github: 'westfield/splunk_logger'

# CSS (cant live in development or css will not get minified)
# git@github.com:rails/rails/issues/10084#issuecomment-20855970
gem 'sass-rails', '~> 4.0.0'
gem 'kss', github: 'kneath/kss' # Gem release pending
gem 'newrelic_rpm'
gem 'thin'
gem 'unicorn'

group :development do
  gem "foreman"
end

group :assets do
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
end

group :development, :test do
  # needed for using have_selector matcher, since rspec-2 removes
  # have_tag matcher
  gem 'webrat'
  gem 'pry'
  gem 'pry-remote'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "rspec-rails"
  gem 'json'
  gem 'rack-proxy', '0.4.0' # Updating it broke our proxying (/api/<service>/...)
  gem 'launchy'
end

group :test do
  gem 'capybara'
  gem 'poltergeist', '~> 1.5'
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
  # Gems for Acceptance tests:
  gem 'mechanize', '2.7.2' # until mime-types dep issue with rails 4.0.2 is resolved
  gem 'capybara-mechanize'
  gem 'rspec_junit_formatter'
end
