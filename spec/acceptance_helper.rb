require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/mechanize'
require 'capybara-webkit'
require 'json'

Capybara.run_server = false
Capybara.app = "Westfield" # this is meant to be the Rack application we are testing against, even though we aren't using it, Mechanize requires it to not be nil
Capybara.default_driver = :mechanize
Capybara.current_session.driver.browser.agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

Capybara.app_host = WestfieldUri::Console.uri_for('customer').to_s.gsub(/\/$/, '')
puts "Using: #{Capybara.app_host}"

Dir[Rails.root.join("spec/acceptance/support/*_helper.rb")].each { |f| require f }

RSpec.configure do |config|
  config.tty = true
  config.include SupportHelper
  config.filter_run_including(:destructive => false) if Rails.env.production?
  config.filter_run_excluding(:destructive => true) if Rails.env.production?
  config.before(:each) do
    set_proxy
  end
end