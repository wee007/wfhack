class MovieService
  class << self
    include ApiClientRequests
    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      body['movies'] || body['movie']
    end

    def request_uri(options={})
      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("http://movie-service.#{Rails.env}.dbg.westfield.com/api/movie/master/movies/#{options}.json")
      else
        uri = URI("http://movie-service.#{Rails.env}.dbg.westfield.com/api/movie/master/movies.json")
        uri.query = options.to_query
        uri
      end
    end
  end
end
