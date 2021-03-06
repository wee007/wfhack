shared_context "regressions" do
  def expect_to_have_tiles(type=nil)
#     wait_for_element '.test-pin-board'
    wait_for_ajax_requests
    expect(page).to have_css('.test-pin-board')
    selector = ".test-tile#{type.nil? ? '' : "-#{type}"}"
    expect(all(selector).length).to be > 2
  end

  def expect_product_page
    expect(page).to have_text "Description", "Available Colours", "Also available at"
    # WSF-5863, product URL should include retailer_code and product_name, e.g: /products/forcast/kyra-suit-pants/49364
    current_url.should match('.*/products/[^/]+/[a-z\-0-9%]+/[0-9]+')
  end

  def expect_product_filter(filter)
    product_search_filter = find('.test-product-search-filters')
      expect(product_search_filter).to have_content(filter)
      expect(product_search_filter).to have_content('Clear all')
  end

  def apply_product_filter(filter)
      find('.test-products-filter-categories').click
      find('.test-products-categories-menu-item', :text => filter).click
      wait_for_ajax_requests
  end

  def go_to_next_results_page
    go_to_results_page "next"
  end

  def go_to_previous_results_page
    go_to_results_page "prev"
  end

  def go_to_results_page(direction)
    within('.test-products-pin-board-pager') do
      find(".test-products-pin-board-pager-link-#{direction}").click
    end
    wait_for_ajax_requests
  end

  def select_random_product
    random('article a').click
  end

end