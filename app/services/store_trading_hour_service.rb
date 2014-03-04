class StoreTradingHourService
  class << self
    include ApiClientRequests

    def build(json_response)
      return StoreTradingHour.new(super(json_response)) unless super(json_response).is_a?(Array)
      super(json_response).map do |json|
        StoreTradingHour.new(json)
      end
    end

    def request_uri(options={})
      if options[:store_id]
        uri = URI("#{ServiceHelper.uri_for('trading-hour')}/store_trading_hours/range.json")
      else
        uri = URI("#{ServiceHelper.uri_for('trading-hour')}/store_trading_hours.json")
      end
      uri.query = options.to_query
      uri
    end
  end
end