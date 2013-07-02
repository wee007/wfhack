class EventService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('event')}/events/#{options}.json")
      elsif options.present?
        uri = URI("#{ServiceHelper.uri_for('event')}/events.json")
        uri.query = options.to_query
        uri
      else
        URI("#{ServiceHelper.uri_for('event')}/events.json")
      end

    end

    def build(json_response)
      response = super(json_response)
      if response.is_a? Array
        response.map { |event| Event.new event }
      else
        Event.new response
      end
    end

  end
end
