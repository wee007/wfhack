class ProductService
  class << self
    include ApiClientRequests
    def build(json)
      results = json.respond_to?(:body) ? json.body : json
      facets = build_facets(results)
      products = results.results
      Hashie::Mash.new products: products, facets: facets
    end

    def build_facets(results)
      facets=Hashie::Mash.new
      results.facets.each do |facet|
        facets[facet.field] = facet
      end
      facets
    end

    def request_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      centre = search_opts.delete :centre_id
      search_opts[:centre] ||= centre
      uri = URI("#{AppConfig.product_service_url}/products/search.json")
      uri.query = search_opts.reject{|k,v|v.blank? || v.is_a?(Array) && v.all?(&:blank?) }.to_query
      uri
    end
  end
end
