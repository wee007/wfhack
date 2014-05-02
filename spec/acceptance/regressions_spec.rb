require 'acceptance_helper'

feature 'Regressions' do
  include_context 'regressions'
  
  background do
    Capybara.current_driver = :webkit
  end
  
  teardown do
    Capybara.use_default_driver
  end
  
  describe 'Entry page' do
    scenario "displays products and other tiles for centres" do
      visit '/'
      expect(page).to have_text 'NSW', 'VIC', 'QLD'
      
      link = random('.test-centre-tile-link')
      href = link[:href]
      log "centre: #{href}"
      link.click
      expect_urls_to_match(current_path, href)
      
      expect_to_have_tiles
      
      visit bust_cache('/bondijunction')
      expect_to_have_tiles
      
      find('.test-main-nav-products-link').click
      expect_to_have_tiles 'product'
      page.all(".test-tile-product .test-tile-meta-desc").each {|p| expect(p.text).to_not be_nil}
      
      first(".test-tile-product .test-tile-link").click
      expect_product_page
    end
  end

  describe 'Basic Search' do
    scenario 'searching for a product shows relevant product results' do
      visit '/bondijunction/products'
      expect(page).to have_css('.test-global-search-input')
      ['Red dress', 'Alannah Hill', 'tops with stripes'].each do |query|
        find('.test-global-search-input').set(query + "\n")
        expect_to_have_tiles 'product'
        expect_product_filter query
      end
    end
  end

  describe 'Nearby Search' do
    scenario 'user can search nearby centres even when there are no product results [WSF-5857 BUG]' do
      visit '/bondijunction/products'
      expect(page).to have_content('Show products at')
      within('.test-show-products-deals-events') do
        expect(page).to have_content '& nearby centres'
      end

      find('.test-global-search-input').set("Therearenoproductsthatmatchthis\n")
      within('.test-show-products-deals-events') do
        expect(page).to have_content '& nearby centres'
      end
    end
  end

  describe 'Filtering stores by category' do
    scenario 'results in correctly filtered results' do
      visit '/carindale/stores'
      find('.test-stores-category-filter-button').click
      expect(page).to have_css('.test-stores-category-filter-drop-down')
      
      within('.test-stores-category-filter-drop-down') do
        find('.test-stores-main-category-link', :text => "Fashion").click
        find('.test-stores-sub-category-link', :text => "Women's").click
      end
      wait_for_ajax_requests
      expect(page).to have_content(/(\d+) Results found/)
    end
  end

  describe 'Basic Facet navigation' do
    scenario 'applying various filters successfully filters the products, and preserves filters across page results' do
      visit '/bondijunction/products'
      within('.test-products-category-filters') do
        expect(page).to have_content 'Categories', 'Stores', 'Brands', 'Colour', 'Price'
      end

      apply_product_filter "Women's"
      expect_product_filter "Women's"

      go_to_next_results_page
      expect_to_have_tiles 'product'
      expect_product_filter "Women's"

      go_to_previous_results_page
      expect_to_have_tiles 'product'
      expect_product_filter "Women's"
    end
  end

  describe 'Retailer click-out intermediate page and PHG tags [WSF-5785]' do
    scenario "user can navigate to product page and click-through to buy from retailer's site" do
      visit '/bondijunction/products'
      
      expect_to_have_tiles 'product'
      within('.test-pin-board') do
        random('.test-tile-product').find('.test-tile-link').click
      end
      expect_product_page
      
      visit page.find(".test-product-click-out-to-retailer")[:href]
    end
  end
end