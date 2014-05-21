include Rails.application.routes.url_helpers

shared_context "seo" do
  def expect_canonical_link_to_match_url
    canonical_link = find('link[rel=canonical]', :visible => false)
    canonical = url_with_sorted_querystring(canonical_link[:href])
    current = url_with_sorted_querystring(current_url)
    expect(clean_url(canonical)).to eql(clean_url(current))
  end
  
  def has_movie_page?(centre)
    if try_visit(centre_path(centre))
      all("a[href='#{centre_movies_path(centre)}']").count > 0
    else
      false
    end
  end
  
  def check_uniqueness(type, items)
    unique = true
    items.each do |hopefully_unique_item, pages_using_it|
      if pages_using_it.count > 1
        log "#{pages_using_it.to_sentence} are using the same #{type}: #{hopefully_unique_item}"
        unique = false
      end
    end
    unique
  end
  
  def check_canonical_links_for(target_pages)
    target_pages.each do |hash|
      name,url = [hash[:name], hash[:url]]
      
      unless url.nil?
        if try_visit(url)
          expect_one('link[rel=canonical]', :visible => false)
          expect_canonical_link_to_match_url
        end
      end
    end
  end
  
  #### METHODS for ensuring querystring params in canonical links and page urls are in the same order
  def url_with_sorted_querystring(url)
    bits = url.split('?')
    path = bits[0]
    qs = bits[1]
    if qs
      qbits = qs.split('&')
      analytics_metadata_params.each { |param| qbits.reject! { |qbit| qbit.include?("#{param}=") } }
      qbits.sort_by!{ |qbit| qbit }
    end
    "#{path}#{(qbits && qbits.any?) ? "?#{qbits.join('&')}" : ''}"
  end
  
  def analytics_metadata_params
    [:gce_var, :utm_expid, :utm_referrer, :gclid, :search_keyword, :search_source]
  end
  
  #### METHODS for getting meta tags and titles from pages being tested
  def get_meta_tags_and_titles_for(target_pages)
    # gathers the meta tags and titles for each page in target_pages
    # and stores them so that we can check uniqueness afterwards
    meta_tags = {}
    titles = {}
    target_pages.each do |hash|
      name,url = [hash[:name], hash[:url]]
      
      unless url.nil?
        if try_visit(url)
          # check for just one non-empty meta description tag
          meta_tag = expect_one('meta[name=description]', :visible => false)
          expect(meta_tag[:content]).not_to be_empty
          stash meta_tags, meta_tag[:content], name
          
          # check for just one non-empty title tag
          title = expect_one('title', :visible => false)
          expect(title).to have_content
          stash titles, title.native.text, name
          
#           log "#{name} : #{url}\n      #{title.native.text}\n      #{meta_tag[:content]}"
        end
      end
    end
    [meta_tags, titles]
  end
  
  def stash(hash, key, value)
    # stores an array of values for a given key
    # eg { :key => [value1] } or { :key => [value1, value2] }
    if hash[key]
      hash[key] << value
    else
      hash[key] = [ value ] 
    end
  end
  
  #### METHODS related to generating a list of pages to test
  def get_target_pages
    # builds a list of pages to target for SEO testing
    # end result is an array of hashs in the format
    # { :name => 'A page name', :url => '/page/url'}
    build_hash_array [:name, :url] do
      pages = [[ 'Home', '/' ]]
      centre_pages.each do |centre|
        pages << centre
      end
      pages
    end
  end
  
  def centre_pages
    # gathers list of centres from the national landing page
    # then for each centre adds relevant pages to the page_list array
    # in the format of [ 'A Page name', '/page/url' ]
    visit '/'
    page_list = []
    elems = all('.test-centre-tile-link')
    elems.each do |elem|
      centre_id = elem[:href].gsub(/^\//, '')
      centre_name = elem.text
      page_list << ["#{centre_name} Centre", centre_path(centre_id)]
      page_list << ["#{centre_name} Stores", centre_stores_path(centre_id)]
      
      page_list << ["#{centre_name} Products", centre_products_path(centre_id)]
      page_list << ["#{centre_name} Product Sample", get_sample_url_for(:product, centre_id)]
      
      if has_movie_page?(centre_id)
        page_list << ["#{centre_name} Movie Page", centre_movies_path(centre_id)]
          # commented out b/c the movie meta descs are not unique - they contain a truncated movie description, which is not unique across centres.
#         page_list << ["#{centre_name} Movie Sample", get_sample_url_for(:movie, centre_id)]
      end
      
      page_list << ["#{centre_name} Services", centre_services_path(centre_id)]
      page_list << ["#{centre_name} Information", centre_info_path(centre_id)]
      
      page_list << ["#{centre_name} Deals", centre_deals_path(centre_id)]
      page_list << ["#{centre_name} Deal Sample", get_sample_url_for(:deal, centre_id)]
      
      page_list << ["#{centre_name} Events", centre_events_path(centre_id)]
      page_list << ["#{centre_name} Event Sample", get_sample_url_for(:event, centre_id)]
    end
    page_list
  end
  
  def build_hash_array(param_names, &block)
    # converts an array of items to a hash with the param_names as keys
    # eg param_name = key1,key2; array = [value1,value2] becomes: { :key1 => value1, :key2 => value2 }
    # expects block to return an array of arrays
    param_count = param_names.count
    hash_array = []
    param_values = instance_eval(&block)
    param_values.each do |values|
      hash = {}
      param_count.times do |i|
        hash.merge!(param_names[i] => values[i])
      end
      hash_array << hash
    end
    hash_array
  end
  
  def get_sample_url_for(type, centre)
    case type
    when :product
      visit centre_products_path(centre)
      selector = ".test-tile-product .test-tile-link"
    when :deal
      visit centre_deals_path(centre)
      selector = ".test-tile-deal .test-tile-link"
    when :event
      visit centre_events_path(centre)
      selector = ".test-tile-event .test-tile-link"
    when :movie
      visit centre_movies_path(centre)
      selector = ".test-movies .test-movie a"
    end
    items = all(selector)
    sample_url = items.count > 0 ? items.first[:href] : nil
    sample_url
  end
end