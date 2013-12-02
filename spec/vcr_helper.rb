require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :faraday
  c.default_cassette_options = { :record => :once, :allow_playback_repeats => true }
  c.configure_rspec_metadata!
end