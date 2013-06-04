class StreamService
  class << self
    include ApiClientRequests
    def build(json)
      json.respond_to?(:body) ? json.body['stream'] : json['stream']
    end

    def request_uri(centre)
      uri = URI("http://stream-service.#{Rails.env}.dbg.westfield.com/api/stream/master/stream.json")
      uri.query = {centre: centre}.to_query
      uri
    end
  end
end
