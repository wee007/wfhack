class CentreService
  class << self
    include ApiClientRequests

    def build(json)
      return null_centre(json) if json.respond_to?(:status) && !json.status.between?(200,299)
      body = json.respond_to?(:body) ? json.body : json
      Centre.build(body)
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

  private

    def null_centre(json)
      NullCentre.new(status: json.status, body: json.body, url: json.env[:url])
    end
  end
end
