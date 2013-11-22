class RedirectorController < ApplicationController
  layout false

  def shopping
    request_path = params[:request_path]

    redirect_base_url = '/products'

    # the type parameter has precedence over everything else
    category = params["type"]

    # safely parse the URL
    clean_uri = URI.extract("http://dummy.tld/" + request_path).first
    request_path = URI.parse(clean_uri).path

    # if no type parameter was specified, we take the last path component
    category ||= request_path.split('/').last.try(:match, /[a-zA-z\-]+/).to_s

    # check to see if the category has been deleted
    if REDIRECTOR_DELETED_CATEGORIES[category]
      category = REDIRECTOR_DELETED_CATEGORIES[category]
    end

    category_mappings = CategoryService.category_mappings

    if category_mappings[category]
      redirect_url = "#{redirect_base_url}?#{category_mappings[category]}=#{category}"
      # if we don't have a category mapping for this url, we redirect to
      # generic products url
    else
      redirect_url = "#{redirect_base_url}"
    end

    redirect_url = "#{redirect_url}&retailer=#{params['retailer']}" if !params["retailer"].nil?

    redirect_to(redirect_url)
  end
end
