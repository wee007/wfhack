require 'acceptance_helper'

feature 'Stores' do

  background do
    set_driver :webkit
  end

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
      wait_for_ajax_requests
      expect(page).to have_css '.test-stores-show'
    end
  end

  describe 'Open categories' do
    scenario "on Sydney stores list" do
      visit "/sydney/stores"
      # Dropdown should be hidden by default
      find('.test-stores-category-filter-drop-down', :visible => false)
      find('.test-stores-category-filter-button').click
      expect(find('.test-stores-category-filter-drop-down')).to be_visible

      category_link = random('.test-stores-main-category-link')
      category_link.click
      sub_categories = find('.test-stores-category-' + category_link['id'])
      expect(sub_categories).to be_visible

      within('.test-stores-category-' + category_link['id']) do
        random('.test-stores-sub-category-link').click
      end
      wait_for_ajax_requests
      expect(page).to have_content(/(\d+) Results found/)

    end
  end

  describe 'Check selected category state is maintained' do
    scenario "on Sydney stores list when moving between index and show" do
      visit "/sydney/stores"

      # Choose a category
      find('.test-stores-category-filter-button').click
      first_category = first('.test-stores-category-link')
      first_category_code = first_category['data-category']
      first_category.click
      wait_for_ajax_requests

      #Choose to show only gift cards
      find('.test-gift-card-toggle').click
      wait_for_ajax_requests

      # Go to store details page
      random('.test-store-link').click
      wait_for_ajax_requests

      # Expect back to stores link to point to category
      expect(find('.test-back-to-store-link')['href']).to eql("/sydney/stores/#{first_category_code}?gift_cards=true")
    end
  end

  describe 'Check map button toggle the map' do
    scenario "on Sydney stores list on palm screen size" do
      page.driver.resize_window(320, 500)
      visit "/sydney/stores"
      find('.test-map-toggle').click
      wait_for_ajax_requests

      expect(page).to have_css('.is-map-view')

    end
  end

end