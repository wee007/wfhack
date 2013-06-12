class CentreService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      if body.is_a? Hash # Or Hashie::Mash etc.
        body['centres'] || body['centre'] || body
      else
        body
      end
    end

    def request_uri(centre=nil,options={})
      if centre.nil? || centre == :all
        uri = URI("#{ServiceHelper.uri_for('centre')}/centres.json")
      else
        uri = URI("#{ServiceHelper.uri_for('centre')}/centres/#{centre}.json")
      end
      uri.query = options.to_query
      uri
    end
  end
end
