require "spec_helper"
require 'vcr_helper'
require 'support/capybara_helper'

feature "Smoke tests", :vcr => {
  # This was recorded against production
  cassette_name: "smoke_tests"
} do

  subject { page.status_code }

  scenario "User vists the national homepage" do
    visit root_path
    should eql(200)
  end

  scenario "User vists the national product pages" do
    # index
    visit products_path
    should eql(200)

    # show
    first(".test-tile a").click
    should eql(200)
  end

  context "in a centre a user vists the" do

    let(:centre_code) { "bondijunction" }

    scenario "homepage" do
      visit centre_path(centre_code)
      should eql(200)
    end

    scenario "info page" do
      visit centre_info_path(centre_code)
      should eql(200)
    end

    scenario "hours page" do
      visit centre_hours_path(centre_code)
      should eql(200)
    end

    scenario "service page" do
      visit centre_services_path(centre_code)
      should eql(200)
    end

    scenario "event pages" do
      # index
      visit centre_events_path(centre_code)
      should eql(200)

      # show
      first(".test-tile a").click
      should eql(200)
    end

    scenario "deal pages" do
      pending "VCR request signature be to updated to include campaign_code"

      # index
      visit centre_deals_path(centre_code)
      should eql(200)

      # show
      first(".test-tile a").click
      should eql(200)
    end

    scenario "product pages" do
      # index
      visit centre_products_path(centre_code)
      should eql(200)

      # show
      first(".test-tile a").click
      should eql(200)
    end

    scenario "movie pages" do
      # index
      visit centre_movies_path(centre_code)
      should eql(200)

      # show
      first(".test-movie a").click
      should eql(200)
    end

    scenario "store pages" do
      # index
      visit centre_stores_path(centre_code)
      should eql(200)

      # show
      first(".test-store a").click
      should eql(200)
    end

    scenario "notice pages" do
      # index
      visit centre_info_path(centre_code)
      should eql(200)

      # show
      first(".test-notice a").click
      should eql(200)
    end

  end

end

