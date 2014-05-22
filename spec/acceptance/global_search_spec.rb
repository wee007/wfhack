require 'acceptance_helper'

feature 'Global Search' do

  before(:each) do
    set_driver :dynamic
  end

  scenario 'results should be returned' do
    visit '/sydney'
    query = 'sdflhjlds'
    find('.test-global-search-input').native.send_key(query)
    wait_for_ajax_requests
    expect(find('.test-global-search-results-dropdown')).to be_visible
    link = first('.test-global-search-results-item-link')
    link_text = link.text
    expect("Search for #{query}").to include(link_text)
    link.click
    # And it should take us to the product search results page
    expect_product_search_results_page
  end

  scenario 'pressing enter should take you to products' do
    visit '/sydney'
    query = "dress"
    find('.test-global-search-input').native.send_keys(query, :Enter)
    wait_for_ajax_requests
    # And it should take us to the product search results page
    expect_product_search_results_page
  end

  scenario 'Keyboard entry should work at searching hours' do
    visit '/sydney'
    query = 'hour'
    find('.test-global-search-input').set(query)
    wait_for_ajax_requests
    find('.test-global-search-input').native.send_keys(:Down, :Enter)
    wait_for_ajax_requests
    # And it should take us directly to the hours page
    page.should have_content("Westfield Centre Hours")
  end
end
