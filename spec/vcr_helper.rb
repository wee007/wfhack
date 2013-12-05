require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :faraday
  c.default_cassette_options = {
    :record => :new_episodes,
    :allow_playback_repeats => true,
    :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:date)]
  }
  c.default_cassette_options = {
    :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:date)]
  }
  c.configure_rspec_metadata!
end

unless ENV["RAILS_ENV"] == 'test'
  VCR.turn_off! :ignore_cassettes => true
end