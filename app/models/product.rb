class Product < Hashie::Mash

  def images
    image_urls
  end

  def image_refs
    image_urls.map { |url| url.gsub %r{^.*/}, '' }
  end

  def available_colours
    details.map do |detail|
      colour = detail.attributes.detect do |attr|
        attr[:name] == 'colour_description'
      end
      colour ? colour[:value] : nil
    end.compact.uniq
  end

  def percent_discount
   ((price - sale_price) / price.to_f * 100).floor
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
      product_name: name_slug,
      id: id
    }
  end

  def meta
    product_category_code = categories ? categories.collect { |cat| cat['code'] } : []

    Meta.new id: id,
             page_title: name,
             description: name,
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
             product_name: [name],
             social_image: images.first
  end

end
