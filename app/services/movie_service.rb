class MovieService
  class << self
    include ApiClientRequests
    def build(movie_json)
      body = movie_json.respond_to?(:body) ? movie_json.body : movie_json

      if body.is_a? Array
        body.map{|movie_json| Movie.new(movie_json)}
      else
        Movie.new body
      end
    end

    def request_uri(options={})
      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('movie')}/movies/#{options}.json")
      else
        uri = URI("#{ServiceHelper.uri_for('movie')}/movies.json")
        uri.query = options.to_query
        uri
      end
    end
  end
end
