require 'acceptance_helper'

feature 'Trading Hours' do
  include_context 'trading_hours'
  
  describe 'Center hours are correct' do
    scenario "for Bondi Junction" do
      visit "/bondijunction/hours"
      centre_hours_table = find('.test-centre-hours-table-0')
      this_weeks_centre_hours.each do |hour|
        expect(centre_hours_table).to have_text(expected_hours_string(hour))
      end
    end
  end
  
  describe 'Store hours are correct' do
    scenario "for David Jones" do
      visit "/bondijunction/hours?store_id=4565#shopping-hours"
      store_hours_table = find('.test-store-hours-table-0')
      this_weeks_store_hours.each do |hour|
        expect(store_hours_table).to have_text(expected_hours_string(hour))
      end
    end
  end
end