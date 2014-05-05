require 'acceptance_helper'

feature 'Stores' do

  background do
    Capybara.current_driver = :webkit
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

end