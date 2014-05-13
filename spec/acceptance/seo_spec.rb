require 'acceptance_helper'

feature 'SEO' do
  include_context 'seo'
  
  before :each do
    set_driver :webkit
  end

  describe 'Canonical links' do
    scenario "only one per page" do
      visit "/sydney/products"
      find('link[rel=canonical]', :visible => false)
    end
    
    scenario "match the page url" do
      visit "/sydney/products"
      expect_canonical_link_to_match_url
      
      find('.test-products-filter-categories').click
      first('.test-products-categories-menu-item').click
      
      visit current_url
      expect_canonical_link_to_match_url
      
      find('.test-products-filter-categories').click
      first('.test-products-sub-categories-menu-item').click
      
      visit current_url
      expect_canonical_link_to_match_url
      
      find('.test-products-filter-categories').click
      first('.test-products-categories-menu-checkbox').click
      find('.test-products-categories-filter-apply').click
      
      visit current_url
      expect_canonical_link_to_match_url
      
      find('.test-products-filter-colours').click
      first('.test-products-colours-menu-checkbox').click
      find('.test-products-colours-filter-apply').click
      
      visit current_url
      expect_canonical_link_to_match_url
    end
  end
end
