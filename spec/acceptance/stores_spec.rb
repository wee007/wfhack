require 'acceptance_helper'

feature 'Stores' do

  background do
    Capybara.current_driver = :webkit
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