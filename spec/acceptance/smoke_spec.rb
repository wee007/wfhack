require 'acceptance_helper'

feature 'Smoke', :smoke => true do
  describe 'Customer Console' do
    scenario 'entry page works as expected' do
      visit '/'
      expect(page).to have_content 'Bondi Junction'
    end
    
    scenario 'application is healthy' do
      visit '/status.json'
      expect(page).to have_content '"healthy":true','"message":"success"'
    end
  end
end