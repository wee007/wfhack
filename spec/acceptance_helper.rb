require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/mechanize'
require 'capybara-webkit'
require 'json'

Capybara.run_server = false
Capybara.app = "Westfield" # this is meant to be the Rack application we are testing against, even though we aren't using it, Mechanize requires it to not be nil
Capybara.default_driver = :mechanize

Capybara.app_host = WestfieldUri::Console.uri_for('customer').to_s.gsub(/\/$/, '')
puts "Using: #{Capybara.app_host}"

Dir[Rails.root.join("spec/acceptance/support/*_helper.rb")].each { |f| require f }

RSpec.configure do |config|
  config.tty = true
  config.include SupportHelper
  config.before(:each) do
    set_proxy
    set_ssl_verify
    redirecting_on
  end
end
  
def environment_greater_than_or_equal_to?(environment)
  # is the current environment >= another environment
  hierarchy = %w[test development systest uat production]
  hierarchy.index(Rails.env) >= hierarchy.index(environment)
end