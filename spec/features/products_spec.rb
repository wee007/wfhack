require "spec_helper"
require 'vcr_helper'
require 'support/capybara_helper'

feature "Product features", :vcr => {
  # This was recorded against production
  cassette_name: "products"
} do

  context "A user visits the national" do
    scenario "xhr product page" do
      visit product_xhr_path
      first(".test-tile-link")['href'].should_not include('bondijunction')
    end
  end

  context "A user visits bondijunction" do
    scenario "xhr product page" do
      visit product_xhr_path(centre: 'bondijunction')
      first(".test-tile-link")['href'].should include('bondijunction')
    end

    scenario "xhr product page, when showing all products" do
      visit product_xhr_path('bondijunction', current_centre: 'bondijunction', centre: 'all')
      first(".test-tile-link")['href'].should_not include('all')
      first(".test-tile-link")['href'].should include('bondijunction')
    end
  end

end