class ProductService

  class << self
    include ApiClientRequests
    def build(json)
      results = json.respond_to?(:body) ? json.body : json
      if results.kind_of?(Array)
        results.collect { |result| Product.new result }
      elsif results.has_key? :facets
        products = results.delete(:results).collect { |result| Product.new result }
        Hashie::Mash.new results.merge products: products
      else
        Product.new results
      end
    end

  private

    def null_product(json)
      NullProduct.new(status: json.status, body: json.body, url: json.env[:url])
    end

    def request_uri(options)
      options.delete :controller
      action = options.delete :action
      options.reject! {|k,v|v.blank? || v.is_a?(Array) && v.all?(&:blank?) }
      if action == 'show'
        show_uri(options)
      elsif action == 'lite'
        lite_uri(options)
      else
        search_uri(options)
      end
    end

    def show_uri(options)
      retailer_code = options.delete :retailer_code
      sku = options.delete :sku
      URI("#{ServiceHelper.uri_for('product')}/retail-chains/#{retailer_code}/products/#{sku}.json")
    end

    def lite_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      centre = search_opts.delete :centre_id
      search_opts[:centre] ||= centre
      uri = URI("#{ServiceHelper.uri_for('product')}/products.json")
      uri.query = search_opts.to_query
      uri
    end

    def search_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      centre = search_opts.delete :centre_id
      search_opts[:centre] ||= centre
      uri = URI("#{ServiceHelper.uri_for('product')}/products/search.json")
      uri.query = search_opts.to_query
      uri
    end
  end
end
