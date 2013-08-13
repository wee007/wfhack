class Product < Hashie::Mash
  def images(width: 469, height: 474)
    images = [resized_url(default_image_url, width: width, height: height)]
    details.each do |detail|
      detail.media.each do |media|
        url = resized_url(media, width: width, height: height)
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

  def meta
    Meta.new title: name,
             image: primary_image,
             product_sku: sku,
             currency: 'AUD',
             retailer_code: retailer_code,
             product_name: name
  end

private
  def resized_url(url, width: 469, height: 474)
    url.sub("[WIDTH]x[HEIGHT]", "#{width}x#{height}")
  end
end