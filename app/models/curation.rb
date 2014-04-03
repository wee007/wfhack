class Curation < Hashie::Mash

  def image
    if _links and _links['image']
      _links['image']['href']
    end
  end

  def kind
    "curation"
  end

  def products
    @products ||= begin
      products = nil
      Service::API.in_parallel do
        products = product_ids.inject [] do |memo, product_id|
          (memo.push ProductService.fetch product_id) rescue memo
        end
      end

      products.compact.map do |product|
        product = ProductService.build product
        # FIXME ProductService represents product#price and #sale_price
        # differently depending upon the action that is envoked.
        # Its index action returns products' prices in dollars and cents,
        # whereas its show action returns prices in whole cents only.
        # Product tiles expect prices in dollars and cents. Such tiles are
        # populated from ProductService's index action so all
        # is hunky-dory. However, curations get their products via
        # ProductService's show action. The same product tile is used;
        # consequently, products' prices are 100x inflated for curations.
        # Yikes!
        product.sale_price /= 100.0 if product.sale_price.is_a? Integer
        product.price /= 100.0 if product.price.is_a? Integer
        product
      end
    end
  end

  def retailers
    @retailer ||= begin
      products.map do |product|
        Hash code: product.retailer_code, name: product.retail_chain_name
      end.uniq
    end
  end

  def meta
    @meta ||= begin
      Meta.new \
        id: id,
        title: name,
        twitter_title: "Check out #{name}",
        email_body: kind,
        image: image,
        kind: kind,
        social_image: image
    end
  end

end
