require 'spec_helper'
require 'vcr_helper'
require 'support/capybara_helper'

describe "Global Search" do
  describe "by default" do
    it "takes you to a product browse search" do
      VCR.use_cassette('global_search') do
        visit centre_path("bondijunction")
        fill_in "global-search", with: "red"
        click_button "Search Products"
        expect(current_url).to match(/\/bondijunction\/products\?.*search_query=red/)
      end
    end
  end
end
