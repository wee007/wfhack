require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/mechanize'
# require 'capybara-webkit'
require 'capybara/poltergeist'
require 'json'

Capybara.run_server = false
Capybara.app = "Westfield" # this is meant to be the Rack application we are testing against, even though we aren't using it, Mechanize requires it to not be nil
Capybara.default_driver = :mechanize
Capybara.default_wait_time = 20

Capybara.app_host = WestfieldUri::Console.uri_for('customer').to_s.gsub(/\/$/, '')
puts "Using: #{Capybara.app_host}"

Dir[Rails.root.join("spec/acceptance/support/*_helper.rb")].each { |f| require f }

RSpec.configure do |config|
  config.tty = true
  config.include SupportHelper
  config.before(:each) do
    set_driver Capybara.default_driver
    redirecting_on
  end
  
#   config.after(:each) do
#     if example.exception && Capybara.current_driver.to_s.include?('poltergeist')
#       meta = example.metadata
#       filename = File.basename(meta[:file_path])
#       line_number = meta[:line_number]
#       screenshot_name = "#{filename}-#{line_number}"
#       snap(screenshot_name, meta[:full_description])
#     end
#   end
end
  
def environment_greater_than_or_equal_to?(environment)
  # is the current environment >= another environment
  hierarchy = %w[test development systest uat production]
  hierarchy.index(Rails.env) >= hierarchy.index(environment)
end