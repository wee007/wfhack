require 'acceptance_helper'

feature 'Stores' do
  include_context 'trading_hours'

  describe 'There are stores in the store list' do
    scenario "for Sydney" do
      visit "/sydney/stores"
      expect(page).to have_css '.test-stores-store-link'
    end
  end

  describe 'View Storefront' do
    scenario "from Sydney stores list" do
      visit "/sydney/stores"
      store_link = random('.test-stores-store-link')
      store_link.click
      expect(page).to have_css '.test-stores-show'
    end
  end

end