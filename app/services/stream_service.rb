class StreamService
  class << self
    def all(centre)
      build(fetch(centre))
    end

    def build(json_response)
      json_response.body['stream']
    end

    def fetch(centre)
      Service::API.get request_uri(centre)
    end

    def request_uri(centre)
      uri = URI("#{ENV['HOST']}/api/stream/master/stream.json")
      uri.query = {centre: centre}.to_query
      uri
    end
  end
end
