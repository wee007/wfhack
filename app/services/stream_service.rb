class StreamService
  class << self
    include ApiClientRequests
    def build(json)
      json.respond_to?(:body) ? json.body['stream'] : json['stream']
    end

    def request_uri(centre)
      uri = URI("#{ServiceHelper.uri_for('stream')}/stream.json")
      uri.query = {centre: centre}.to_query
      uri
    end
  end
end
