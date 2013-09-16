class ParkingService
  class << self
    include ApiClientRequests

    def build(json)
      return null_centre(json) if json.respond_to?(:status) && !json.status.between?(200,299)
      body = json.respond_to?(:body) ? json.body : json
      Parking.new(body)
    end

    def request_uri(centre,options={})
      uri = URI("#{ServiceHelper.uri_for('centre')}/parkings/#{centre}.json")
      uri.query = options.to_query
      uri
    end
  end
end
