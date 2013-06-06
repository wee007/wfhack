class CentreService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      body['centres'] || body['centre'] || body
    end

    def request_uri(centre=nil,options={})
      if centre.nil? || centre == :all
        uri = URI("#{AppConfig.centre_service_url}/centres.json")
      else
        uri = URI("#{AppConfig.centre_service_url}/centres/#{centre}.json")
      end
      uri.query = options.to_query
      uri
    end
  end
end
