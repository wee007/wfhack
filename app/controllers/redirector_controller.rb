class RedirectorController < ApplicationController
  require 'csv'

  layout false

  def shopping
    request_path = params[:request_path]

    redirect_base_url = '/products'

    @deleted_categories ||= read_csv("lib/assets/deleted_categories.csv")

    @category_mappings ||= read_csv("lib/assets/categories.csv")

    # the type parameter has precedence over everything else
    category = params["type"]
    
    # if no type parameter was specified, we take the last path component
    category ||= URI(request_path).path.split("/").last

    # check to see if the category has been deleted
    if @deleted_categories[category]
      category = @deleted_categories[category]
    end

    if @category_mappings[category]
      redirect_url = "#{redirect_base_url}?#{@category_mappings[category]}=#{category}"
      # if we don't have a category mapping for this url, we redirect to
      # generic products url
    else
      redirect_url = "#{redirect_base_url}"
    end

    redirect_url = "#{redirect_url}&retailer=#{params['retailer']}" if !params["retailer"].nil?

    redirect_to(redirect_url)
  end

private
  
  def read_csv(filename)
    categories = {}

    CSV.foreach(filename) do |row|
      categories[row[0].strip] = row[1].strip
    end

    categories
  end

end
