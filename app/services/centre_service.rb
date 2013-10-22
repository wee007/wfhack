class CentreService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      Centre.build(body)
    end

    def group_by_state(json)
      centres = build json
      centres.group_by{ |c| c.state } if centres.present?
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
