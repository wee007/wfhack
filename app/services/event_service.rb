class EventService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{AppConfig.event_service_url}/events/#{options}.json")
      elsif options.present?
        uri = URI("#{AppConfig.event_service_url}/events.json")
        uri.query = options.to_query
        uri
      else
        URI("#{AppConfig.event_service_url}/events.json")
      end

    end
  end
end
