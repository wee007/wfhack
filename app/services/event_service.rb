require "addressable/uri"

class EventService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("http://event-service.#{Rails.env}.dbg.westfield.com/api/event/master/events/#{options}.json")
      elsif options.present?
        query = Addressable::URI.new
        query.query_values = options
        URI("http://event-service.#{Rails.env}.dbg.westfield.com/api/event/master/events.json?#{query.query}")
      else
        URI("http://event-service.#{Rails.env}.dbg.westfield.com/api/event/master/events.json")
      end
    end
  end
end
