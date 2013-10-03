class MovieSessionService
  class << self
    include ApiClientRequests
    def build(json_response)
      super(json_response.body['movie_sessions']).map do |session_json|
        MovieSession.new(session_json)
      end
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
