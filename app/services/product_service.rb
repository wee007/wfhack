class ProductService
  class << self
    include ApiClientRequests
    def build(json)
      results = json.respond_to?(:body) ? json.body : json
      if results.has_key? :facets
        facets = build_facets(results)
        products = results.delete :results
        pagination = build_pagination(results)
        sort_options = results.delete(:display_options)[:sort_options]
        Hashie::Mash.new results.merge(products: products, facets: facets,
          sort_options: sort_options).merge(pagination)
      else
        Product.new results
      end
    end

  private

    def build_pagination(results)
      total_pages = ([1,results[:count]-1].max / results.rows) + 1
      current_page = (results.start + results.rows) / results.rows
      {current_page: current_page, total_pages: total_pages}
    end

    def build_facets(results)
      facets = Hashie::Mash.new
      results.facets.each do |facet|
        facets[facet.field] = facet
      end
      facets
    end

    def request_uri(options)
      options.delete :controller
      action = options.delete :action
      options.reject! {|k,v|v.blank? || v.is_a?(Array) && v.all?(&:blank?) }
      if action == 'show'
        show_uri(options)
      else
        search_uri(options)
      end
    end

    def show_uri(options)
      retailer_code = options.delete :retailer_code
      sku = options.delete :sku
      URI("#{ServiceHelper.uri_for('product')}/retail-chains/#{retailer_code}/products/#{sku}.json")
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
