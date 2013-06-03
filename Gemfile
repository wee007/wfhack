ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '4.0.0.rc1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'dotenv-rails'
gem 'health_check'
gem 'faraday-http-cache', git: 'git@github.dbg.westfield.com:ldewey/faraday-http-cache.git'
gem 'service_api', git: 'git@github.dbg.westfield.com:bschwarz/service_api.git'

group :development do
  gem "unicorn"
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