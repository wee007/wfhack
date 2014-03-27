class SearchService
  class << self
    include ApiClientRequests

    def build(search_json)
      body = search_json.respond_to?(:body) ? search_json.body : search_json
      if body.is_a? Array
        body.map{|search_json| Search.new(search_json)}
      else
        Search.new body
      end
    end

    def request_uri(options)
      uri = URI("#{ServiceHelper.uri_for('search')}/search.json")
      uri.query = options.to_query
      uri
    end

  end
end