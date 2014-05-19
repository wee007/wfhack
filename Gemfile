ruby "2.0.0"
source "https://rubygems.org"

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
gem 'service_api', git: 'git@github.com:westfield/service_api.git', :ref => '57e171dc8dd05622505d81be840390bf6f9612fd'
gem 'faraday', '0.8.8'
gem 'faraday_middleware'
gem 'service_helper', git: 'git@github.com:westfield/service_helper.git'
gem 'hashie'
gem 'cloudinary'
gem 'sitemap_generator'
gem 'sterile'
gem 'parallel'

# Caching
gem 'redis-rails'

# Presentation, pagination etc.
gem 'kaminari'
gem 'money'
gem 'truncate'
gem 'draper', '~> 1.3'

gem 'splunk_logger', git: 'git@github.com:westfield/splunk_logger.git'

# CSS (cant live in development or css will not get minified)
# git@github.com:rails/rails/issues/10084#issuecomment-20855970
gem 'sass-rails', '~> 4.0.0'
gem 'kss', git: 'git@github.com:kneath/kss.git' # Gem release pending
gem 'newrelic_rpm'

group :development do
  gem "foreman"
end


group :development, :test do
  # needed for using have_selector matcher, since rspec-2 removes
  # have_tag matcher
  gem 'webrat'
  gem 'pry'
  gem 'pry-remote'
  gem "debugger"
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "rspec-rails"
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'json'
  gem 'rack-proxy', '0.4.0' # Updating it broke our proxying (/api/<service>/...)
  gem 'launchy'
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
  # Gems for Acceptance tests:
  gem 'mechanize', '2.7.2' # until mime-types dep issue with rails 4.0.2 is resolved
  gem 'capybara-webkit'
  gem 'capybara-mechanize'
  gem 'rspec_junit_formatter'
end
