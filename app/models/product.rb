class Product < Hashie::Mash
  def images
    images = [default_image_url]
    details.each do |detail|
      detail.media.each do |media|
        url = media
        images.append url unless images.include?(url)
      end
    end
    images
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

    Meta.new title: name,
             image: primary_image,
             # For universal tagging
             product_sku: [sku],
             product_category_code: product_category_code,
             currency: 'AUD',
             retailer_code: retailer_code,
             product_name: [name]
  end

end