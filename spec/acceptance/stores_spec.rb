require 'acceptance_helper'

feature 'Stores' do

  describe 'There are stores in the store list' do
    scenario "for Sydney" do
      visit "/sydney/stores"
      expect(page).to have_css '.test-store-link'
    end
  end

  describe 'View Storefront' do
    scenario "from Sydney stores list" do
      visit "/sydney/stores"
      store_link = random('.test-store-link')
      store_link.click
      expect(page).to have_css '.test-stores-show'
    end
  end

end