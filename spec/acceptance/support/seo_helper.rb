shared_context "seo" do
  def expect_canonical_link_to_match_url
    canonical_link = find('link[rel=canonical]', :visible => false)
    canonical = url_with_sorted_querystring(canonical_link[:href])
    current = url_with_sorted_querystring(current_url)
#     log "#{canonical.gsub(Capybara.app_host, '')}   :::   #{current.gsub(Capybara.app_host, '')}"
    expect(canonical).to eql(current)
  end
  
  def google_experiment_params
    [:gce_var, :utm_expid, :utm_referrer]
  end
  
  def url_with_sorted_querystring(url)
    bits = url.split('?')
    path = bits[0]
    qs = bits[1]
    if qs
      qbits = qs.split('&')
      google_experiment_params.each { |param| qbits.reject! { |qbit| qbit.include?("#{param}=") } }
      qbits.sort_by!{ |qbit| qbit }
    end
    "#{path}#{qbits ? "?#{qbits.join('&')}" : ''}"
  end
end
