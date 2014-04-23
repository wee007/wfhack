require 'acceptance_helper'

feature 'Regressions' do
  include_context 'regressions'
  
  background do
    Capybara.current_driver = :webkit
  end
  
  describe 'Entry page', :destructive => false do
    scenario "displays products and other tiles for centres" do
      visit '/'
      expect(page).to have_text 'NSW', 'VIC', 'QLD'
      click_link 'Liverpool'
      expect(current_path).to eql('/liverpool/')
      expect_to_have_tiles
      
      visit bust_cache('/bondijunction')
      expect_to_have_tiles
      
      click_link 'Products'
      expect_to_have_tiles
      page.all(:css, "p.tile__meta__desc").each {|p| expect(p.text).to_not be_nil}
      
      all(:css, ".test-tile-link").first.click
      expect_product_page
    end
  end

  describe 'Basic Search', :destructive => false do
    scenario 'searching for a product shows relevant product results' do
      visit '/bondijunction/products'
      expect(page).to have_css('#global-search')
      ['Red dress', 'Alannah Hill', 'tops with stripes'].each do |query|
        fill_in 'global-search', :with => query + "\n"
        expect_to_have_tiles
        expect_product_filter query
      end
    end
  end

  describe 'Nearby Search', :destructive => false do
    scenario 'user can search nearby centres even when there are no product results [WSF-5857 BUG]' do
      visit '/bondijunction/products'
      expect(page).to have_content('Show products at')
      within('#show-products-deals-events') do
        expect(page).to have_content '& nearby centres'
      end

      fill_in 'global-search', :with => "Therearenoproductsthatmatchthis\n"
      within('#show-products-deals-events') do
        expect(page).to have_content '& nearby centres'
      end
    end
  end

  describe 'Filtering stores by category', :destructive => false do
    scenario 'results in correctly filtered results' do
      visit '/carindale/stores'
      click_button 'Category'
      expect(page).to have_css('#category-store-filter')

      within '#stores-main-categories' do
        click_link "Fashion"
      end
      click_link "Women's"
      wait_for_ajax_requests
      expect(page).to have_content(/(\d+) Results found/)
    end
  end

  describe 'Basic Facet navigation', :destructive => false do
    scenario 'applying various filters successfully filters the products, and preserves filters across page results' do
      visit '/bondijunction/products'
      within('#filters') do
        expect(page).to have_content 'Categories', 'Stores', 'Brands', 'Colour', 'Price'
      end

      apply_product_filter "Women's"
      expect_product_filter "Women's"

      go_to_next_results_page
      expect_to_have_tiles
      expect_product_filter "Women's"

      go_to_previous_results_page
      expect_to_have_tiles
      expect_product_filter "Women's"
    end
  end

  describe 'Retailer click-out intermediate page and PHG tags [WSF-5785]', :destructive => false do
    scenario "user can navigate to product page and click-through to buy from retailer's site" do
      Capybara.current_driver = :mechanize
      visit '/bondijunction/products'
      
      select_random_product
      expect_product_page
      
      redirect_page = page.find(:css, ".js-redirect")['href']
      visit redirect_page
    end
  end
end