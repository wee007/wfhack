class ParkingService
  class << self
    include ApiClientRequests

    def build(json)
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
