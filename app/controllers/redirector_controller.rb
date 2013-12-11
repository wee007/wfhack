class RedirectorController < ApplicationController
  layout false
  include RedirectorHelper

  def shopping
    request_path = params[:request_path]

    redirect_base_url = '/products'

    # the type parameter has precedence over everything else
    # otherwise, extract the category
    category = params["type"] || extract_category_from_url(request_path)

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

    redirect_to(redirect_url, :status => 301)
  end
end
