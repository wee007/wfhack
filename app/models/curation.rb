class Curation < Hashie::Mash

  def image
    _links['image']['href']
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
        ProductService.build product
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
    @_meta ||= begin
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
