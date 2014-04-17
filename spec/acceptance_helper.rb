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
puts "Checking against: #{Capybara.app_host}"

Dir[Rails.root.join("spec/acceptance/support/*_helper.rb")].each do |f|
  require f
  type = f.split('/').last.gsub('_helper.rb', '')
  unless type == 'support'
    RSpec.configure do |config|
      config.treat_symbols_as_metadata_keys_with_true_values = true
      config.include "#{type}_helper".camelize.constantize, type.to_sym => true
    end
  end
end

RSpec.configure do |config|
  config.tty = true
  config.include SupportHelper
  config.filter_run_including(:destructive => false) if Rails.env.production?
  config.filter_run_excluding(:destructive => true) if Rails.env.production?
end