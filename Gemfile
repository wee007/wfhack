ruby "2.0.0"
source "https://rubygems.org"

gem 'rails', '4.0.0.rc1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'dotenv-rails'
gem 'health_check'
gem 'service_api', git: 'git@github.dbg.westfield.com:digital/service_api.git'
gem 'settingslogic'
gem 'faraday'
gem 'faraday_middleware'
gem 'service_helper',
  git: 'git@github.dbg.westfield.com:digital/service_helper.git',
  branch: 'master'

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

group :test do
  gem 'vcr'
end

group :production do
  gem "unicorn"
end
