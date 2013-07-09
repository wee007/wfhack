ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '~> 4.0.0'

# Servers and environment
gem 'dotenv-rails'
gem 'settingslogic'

# Javascript
gem 'gon'

# For operations
gem 'health_check'

# For calling APIs, response parsing etc.
gem 'service_api', git: 'git@github.dbg.westfield.com:digital/service_api.git'
gem 'faraday'
gem 'faraday_middleware'
gem 'service_helper',
  git: 'git@github.dbg.westfield.com:digital/service_helper.git',
  branch: 'master'
gem 'hashie'

# Presentation, pagination etc.
gem 'kaminari'
gem 'money'

group :development do
  gem "foreman"
end

group :development, :test do
  gem 'pry'
  gem 'pry-remote'
  gem "debugger"
  gem "rspec-rails"
  gem 'sass-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'guard', '~> 1.8.0'
  gem 'guard-livereload', '~> 1.4.0'
  gem 'rack-livereload', '~> 0.3.15'
  gem 'kss', git: 'https://github.com/kneath/kss.git' # Gem release pending
  gem "jasminerice", git: 'https://github.com/bradphelan/jasminerice.git'
  gem 'json'
  gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-jasmine', git: 'https://github.com/cwalsh/guard-jasmine.git' # Fix coverage issue
  gem 'rack-proxy'
end

group :test do
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
end
