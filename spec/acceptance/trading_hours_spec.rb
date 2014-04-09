require 'acceptance_helper'
require 'trading_hours_helper'

feature 'Centre has correct trading Hours', :destructive => false do
  scenario "Bondi Junction has correct trading hours" do
    visit "/bondijunction/hours"
    hours_table = find('#tab-0 table', :text => 'Centre Hours')
    this_weeks_centre_hours.each do |hour|
      expect(hours_table).to have_text(expected_hours_string(hour))
    end
  end
end

feature 'Store has correct trading Hours', :destructive => false do
  scenario "David Jones has correct trading hours" do
    visit "/bondijunction/hours?store_id=4565#shopping-hours"
    hours_table = find('#tab-0 #shopping-hours table')
    this_weeks_store_hours.each do |hour|
      expect(hours_table).to have_text(expected_hours_string(hour))
    end
  end
end
