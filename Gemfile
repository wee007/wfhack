ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '4.0.0.rc1'

# Servers and environment
gem "unicorn"
gem 'dotenv-rails'
gem 'settingslogic'

# Javascript
gem 'jquery-rails'
gem 'turbolinks'
gem 'chosen-rails'

# For operations
gem 'health_check'

# For calling APIs, response parsing etc.
gem 'service_api', git: 'git@github.dbg.westfield.com:digital/service_api.git'
gem 'faraday'
gem 'faraday_middleware'
gem 'service_helper',
  git: 'git@github.dbg.westfield.com:digital/service_helper.git',
  branch: 'master'

group :development do
  gem "foreman"
end

group :development, :test do
  gem 'pry'
  gem "debugger"
  gem "rspec-rails"
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
end

group :test do
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
end
