class StreamService
  class << self
    include ApiClientRequests
    def build(json_response)
      json_response.body['stream']
    end

    def request_uri(centre)
      uri = URI("#{ENV['HOST']}/api/stream/master/stream.json")
      uri.query = {centre: centre}.to_query
      uri
    end
  end
end
