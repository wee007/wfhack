class StoreTradingHourService
  class << self
    include ApiClientRequests

    def build(json_response)
      return StoreTradingHour.new(super(json_response)) unless super(json_response).is_a?(Array)
      super(json_response).map do |json|
        StoreTradingHour.new(json)
      end
    end

    def request_uri(store_id, options={})
      uri = URI("#{ServiceHelper.uri_for('trading-hour')}/store_trading_hours/range.json")
      uri.query = {store_id: store_id}.merge(options).to_query
      uri
    end
  end
end