include Rails.application.routes.url_helpers

shared_context "seo" do
  def expect_canonical_link_to_match_url
    canonical_link = find('link[rel=canonical]', :visible => false)
    canonical = url_with_sorted_querystring(canonical_link[:href])
    current = url_with_sorted_querystring(current_url)
    expect(clean_url(canonical)).to eql(clean_url(current))
  end
  
  def analytics_metadata_params
    [:gce_var, :utm_expid, :utm_referrer, :gclid, :search_keyword, :search_source]
  end
  
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
  
  def _target_pages
    build_hash_array [:name, :url, :options] do
      pages = [[ 'Home', '/' ]]
      centre_pages.each do |centre|
        pages << centre
      end
      pages
    end
  end
  
  def centre_pages
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
  
  def stash(hash, key, value)
    # stores an array of values for a given key
    if hash[key]
      hash[key] << value
    else
      hash[key] = [ value ] 
    end
  end
  
  def has_movie_page?(centre)
    visit centre_path(centre)
    all("a[href='#{centre_movies_path(centre)}']").count > 0
  end
  
  def get_meta_tags_and_titles_for(target_pages)
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
        end
      end
    end
    [meta_tags, titles]
  end
  
  def check_uniqueness(type, items)
    unique = true
    items.each do |item, users|
      if users.count > 1
        log "#{users.to_sentence} are using the same #{type}: #{item}"
        unique = false
      end
    end
    unique
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
  
  def try_visit(url)
    success = true
    visit(url) rescue success = false
    success
  end
end