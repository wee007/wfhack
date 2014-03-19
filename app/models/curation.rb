class Curation < Hashie::Mash

  def image
    _links['image']['href']
  end

  def start_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
  end

  def end_date(strftime = nil)
    strftime ? Time.parse(super).strftime(strftime) : super
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

      products.map do |product|
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

  # def meta
  #   Meta.new id: id,
  #            title: name,
  #            image: image,
  #            kind: kind
  # end

  # def icon
  #   detect_tile || "search"
  # end

end
