class MovieSessionService
  class << self
    include ApiClientRequests
    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      body['movie_sessions'] || body['movie_session']
    end

    def request_uri(options={})
      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('movie')}/movie_sessions/#{options}.json")
      else
        uri = URI("#{ServiceHelper.uri_for('movie')}/movie_sessions.json")
        uri.query = options.to_query
        uri
      end
    end
  end
end
