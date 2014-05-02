require 'acceptance_helper'

feature 'Redirecting' do
  include_context 'redirects'
  
  if environment_greater_than_or_equal_to? 'systest' # runs in systest and above b/c the redirects don't work in dev
    describe 'to an INTERNAL address' do
      scenario "sends the user to the correct destination" do
        internal_redirect_list.each do |redirect|
          log "#{redirect[:from]} >> #{redirect[:to]}"
          visit redirect[:from]
          expect_urls_to_match current_url, "#{Capybara.app_host}#{redirect[:to]}"
        end
      end
      
      scenario "responds with a 301" do
        redirecting_off
        internal_redirect_list.each do |redirect|
          visit redirect[:from]
          expect(page.status_code).to eql(301)
        end
      end
    end
    
    describe 'to an EXTERNAL address' do
      scenario "sends the user to the correct destination" do
        Capybara.current_driver = :webkit
        external_redirect_list.each do |redirect|
          log "#{redirect[:from]} >> #{redirect[:to]}"
          visit redirect[:from]
          expect_urls_to_match current_url, redirect[:to]
        end
        Capybara.use_default_driver
      end
      
      scenario "responds with a 301" do
        redirecting_off
        external_redirect_list.each do |redirect|
          visit redirect[:from]
          expect(page.status_code).to eql(301)
        end
      end
    end
  end
end