ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '~> 4.0.0'

# Servers and environment
gem "unicorn"
gem 'dotenv-rails'
gem 'settingslogic'

# Javascript
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'chosen-rails'
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

# Presentation, pagination etc.
gem 'kaminari'

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
end

group :test do
  gem 'vcr'
  gem 'nokogiri'
  gem 'simplecov'
  gem "jasminerice", :git => 'https://github.com/bradphelan/jasminerice.git'
  gem 'json', '~> 1.7.7'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-jasmine'
end
