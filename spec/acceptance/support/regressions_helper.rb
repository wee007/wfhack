shared_context "regressions" do
  def expect_to_have_tiles
    wait_for_element '.pin-board.is-loaded'
    expect(page).to have_css('.pin-board')
    expect(all(:css, ".tile").length).to be > 2
  end
  
  def expect_product_page
    expect(page).to have_text "Description", "Available Colours", "Also available at"
    # WSF-5863, product URL should include retailer_code and product_name, e.g: /products/forcast/kyra-suit-pants/49364
    current_url.should match('.*/products/[^/]+/[a-z\-0-9%]+/[0-9]+')
  end
  
  def expect_product_filter(filter)
    within('div.tags') do
      expect(page).to have_content 'Clear all', filter
    end
  end
  
  def apply_product_filter(filter)
    within('#filters') do
      click_button 'Categories'
      click_link filter
      wait_for_ajax_requests
    end
  end
  
  def go_to_next_results_page
    go_to_results_page "Next"
  end
  
  def go_to_previous_results_page
    go_to_results_page "Prev"
  end
  
  def go_to_results_page(page)
    within('nav.pager') do
      click_link page
    end
    wait_for_ajax_requests
  end
  
  def select_random_product
    r = rand(page.all('article a').size)
    page.all('article a')[r].click
  end
end