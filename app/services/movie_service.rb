class MovieService
  class << self
    include ApiClientRequests
    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      body['movies'] || body['movie']
    end

    def request_uri(options={})
      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{AppConfig.movie_service_url}/movies/#{options}.json")
      else
        uri = URI("#{AppConfig.movie_service_url}/movies.json")
        uri.query = options.to_query
        uri
      end
    end
  end
end
