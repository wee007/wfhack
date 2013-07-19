class CentreTradingHourService
  class << self
    include ApiClientRequests

    def build(json)
      # This is just a STUB HACK REMOVE ME!!!!
      # body = json.respond_to?(:body) ? json.body : json
      # CentreTradingHour.build(body)



    end

    def request_uri(centre=nil, options={})
      if centre.nil? || centre == :all
        uri = URI("#{ServiceHelper.uri_for('centre')}/trading_hours.json")
      else
        uri = URI("#{ServiceHelper.uri_for('centre')}/trading_hours/#{centre}.json")
      end
      uri.query = options.to_query
      uri
    end
  end
end
