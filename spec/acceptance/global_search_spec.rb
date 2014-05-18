require 'acceptance_helper'

feature 'Global Search' do

  before(:each) do
    set_driver :webkit
  end

  scenario 'results should be returned' do
    visit '/sydney'
    query = 'sdflhjlds'
    find('.test-global-search-input').set(query)
    wait_for_ajax_requests
    expect(page).to have_content(query)
    find('.js-global-search-dummy-search').click
    # And it should take us to the products search
    page.should have_content("Products Filter")
  end

  scenario 'pressing enter should take you to products' do
    visit '/sydney'
    query = "hour\n"
    find('.test-global-search-input').set(query)
    page.should have_content("Products Filter")
  end

  scenario 'Keyboard entry should work at searching hours' do
    visit '/sydney'
    query = 'hour'
    find('.test-global-search-input').set(query)
    wait_for_ajax_requests
    send_keycode_to_selector 40, '.test-global-search-input'
    send_keycode_to_selector 13, '.test-global-search-input'
    page.should have_content("Westfield Centre Hours")
  end

end