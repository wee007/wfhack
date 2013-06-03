ruby "2.0.0"

if ENV["RAILS_ENV"] == "production"
  source "http://rubygems.org" # Heroku deployment
else
  source "http://gems.dbg.westfield.com"
end

gem 'rails', '4.0.0.rc1'
gem 'jquery-rails'
gem 'turbolinks'

gem 'health_check'

gem 'faraday-http-cache', git: 'git@github.dbg.westfield.com:ldewey/faraday-http-cache.git'
gem 'service_api', git: 'git@github.dbg.westfield.com:bschwarz/service_api.git'

group :development do
  gem "thin"
  gem "foreman"
end

group :development, :test do
  gem "debugger"
  gem "rspec-rails"
  gem 'sass-rails', '~> 4.0.0.rc1'
  gem 'uglifier', '>= 1.3.0'
  gem 'coffee-rails', '~> 4.0.0'
end

group :production do
  gem "unicorn"
end
