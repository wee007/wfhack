class EventService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("http://event-service.#{AppConfig.service_host}/api/event/master/events/#{options}.json")
      elsif options.present?
        uri = URI("http://event-service.#{AppConfig.service_host}/api/event/master/events.json")
        uri.query = options.to_query
        uri
      else
        URI("http://event-service.#{AppConfig.service_host}/api/event/master/events.json")
      end

    end
  end
end
