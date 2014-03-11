require "spec_helper"
require 'vcr_helper'
require 'support/capybara_helper'

feature "Smoke tests", :vcr => {
  # This was recorded against production
  cassette_name: "smoke_tests"
} do

  context "User visits the national" do

    scenario "homepage" do
      visit root_path
      page.status_code.should eql(200)
    end

    scenario "product pages" do
      # index
      visit products_path
      page.status_code.should eql(200)

      # show
      first(".test-tile-link").click
      page.status_code.should eql(200)
    end

    scenario "terms and conditions" do
      visit "/terms-conditions"
      page.status_code.should eql(200)
    end

    scenario "privacy policy" do
      visit "/privacy-policy"
      page.status_code.should eql(200)
    end

    scenario "robots.txt" do
      visit "/robots.txt"
      page.status_code.should eql(200)
    end

  end

  context "in a centre a user visits the" do

    let(:centre_code) { "bondijunction" }

    scenario "homepage" do
      visit centre_path(centre_code)
      page.status_code.should eql(200)
    end

    scenario "info page" do
      visit centre_info_path(centre_code)
      page.status_code.should eql(200)
    end

    # scenario "hours page" do
    #   visit centre_hours_path(centre_code)
    #   page.status_code.should eql(200)
    # end

    scenario "service page" do
      visit centre_services_path(centre_code)
      page.status_code.should eql(200)
    end

    scenario "event pages" do
      # index
      visit centre_events_path(centre_code)
      page.status_code.should eql(200)

      # show
      first(".test-tile-link").click
      page.status_code.should eql(200)
    end

    scenario "deal pages" do
      # index
      visit centre_deals_path(centre_code)
      page.status_code.should eql(200)

      # show
      first(".test-tile-link").click
      page.status_code.should eql(200)
    end

    scenario "product pages" do
      # index
      visit centre_products_path(centre_code)
      page.status_code.should eql(200)

      # show
      first(".test-tile-link").click
      page.status_code.should eql(200)
    end

    scenario "movie pages" do
      # index
      visit centre_movies_path(centre_code)
      page.status_code.should eql(200)

      # show
      first(".test-movie a").click
      page.status_code.should eql(200)
    end

    scenario "store pages" do
      # index
      visit centre_stores_path(centre_code)
      page.status_code.should eql(200)

      # show
      first(".test-store a").click
      page.status_code.should eql(200)
    end

    scenario "notice pages" do
      # index
      visit centre_info_path('carindale')
      page.status_code.should eql(200)

      # show
      first(".test-notice a").click
      page.status_code.should eql(200)
    end

    scenario "styleguide" do
      # index
      visit styleguide_index_path
      page.status_code.should eql(200)

      # show
      visit styleguide_path('base')
      page.status_code.should eql(200)

      # static
      visit styleguide_path('static/social_share')
      page.status_code.should eql(200)
    end

  end

end

