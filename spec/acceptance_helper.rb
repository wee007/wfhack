require File.expand_path("../../config/environment", __FILE__)
dir = "#{File.dirname(__FILE__)}/acceptance/support"
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/mechanize'
require 'json'
require 'support_helper'

Capybara.run_server = false
Capybara.app = "Westfield" # this is meant to be the Rack application we are testing against, even though we aren't using it, Mechanize requires it to not be nil
Capybara.default_driver = :mechanize

Capybara.app_host = WestfieldUri::Console.uri_for('customer').to_s.gsub(/\/$/, '')
puts "Checking against: #{Capybara.app_host}"

RSpec.configure do |config|
  config.tty = true
  config.include AcceptanceSupportHelpers
  config.filter_run_including(:destructive => false) if Rails.env.production?
end