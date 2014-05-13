require 'acceptance_helper'
include Rails.application.routes.url_helpers

feature 'SEO' do
  include_context 'seo'
  
  before :each do
    set_driver :webkit
  end

  describe 'Canonical links for Product search' do
    scenario "has only one per page" do
      visit "/sydney/products"
      expect_one('link[rel=canonical]', :visible => false)
    end
    
    scenario "search results matches the page url" do
      sample_urls.each do |url|
        visit url
        expect_canonical_link_to_match_url
      end
    end
  end

  describe 'Canonical links for Product page' do
    scenario "has only one and it matches the page url" do
      visit '/sydney/products'
      first('.test-tile-product .test-tile-link').click
      expect_one('link[rel=canonical]', :visible => false)
      expect_canonical_link_to_match_url
    end
  end
end