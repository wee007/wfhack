ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '4.0.0.rc2'

# Servers and environment
gem "unicorn"
gem 'dotenv-rails'
gem 'settingslogic'

# Javascript
gem 'jquery-rails'
gem 'jquery-ui-rails'
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

# Presentation, pagination etc.
gem 'kaminari'

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
  gem 'guard', '~> 1.8.0'
  gem 'guard-livereload', '~> 1.4.0'
  gem 'rack-livereload', '~> 0.3.15'
  gem 'kss', github: 'benschwarz/kss' # PR 69 pending
end

group :test do
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
end
