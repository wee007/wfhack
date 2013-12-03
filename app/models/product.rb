class Product < Hashie::Mash

  def images
    image_urls
  end

  def available_colours
    details.map do |detail|
      colour = detail.attributes.detect do |attr|
        attr[:name] == 'colour_description'
      end
      colour ? colour[:value] : nil
    end.compact.uniq
  end

  def primary_image
    _links ? _links[:image][:href] : default_image_url || images.first
  end

  def kind
    self.class.name.downcase
  end

  def to_param
    {
      retailer_code: retailer_code,
      product_name: name.to_slug,
      id: id
    }
  end

  def meta
    product_category_code = categories ? categories.collect { |cat| cat['code'] } : []

    Meta.new id: id,
             title: name,
             twitter_title: "What do you think of #{name}?",
             email_body: "item",
             image: primary_image,
             kind: kind,
             # For universal tagging
             product_sku: [sku],
             product_category_code: product_category_code,
             currency: 'AUD',
             retailer_code: retailer_code,
             product_name: [name]
  end

end