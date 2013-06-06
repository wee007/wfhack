class ProductService
  class << self
    include ApiClientRequests
    def build(json)
      json.respond_to?(:body) ? json.body : json
    end

    def request_uri(options)
      search_opts = ({page:1, rows: 50}.merge options).with_indifferent_access
      search_opts[:centre] ||= search_opts.delete :centre_id
      uri = URI("#{AppConfig.product_service_url}/products/search.json")
      uri.query = search_opts.to_query
      uri
    end
  end
end
