class StoreTradingHourService
  class << self
    include ApiClientRequests

    def build(json_response)
      return StoreTradingHour.new(super(json_response)) unless super(json_response).is_a?(Array)
      super(json_response).map do |json|
        StoreTradingHour.new(json)
      end
    end

    def request_uri(store_id=nil, options={})
      if store_id.nil? || store_id == :all
        uri = URI("#{ServiceHelper.uri_for('store')}/store_trading_hours.json")
      else
        uri = URI("#{ServiceHelper.uri_for('store')}/stores/#{store_id}/store_trading_hours/range.json")
      end

      uri.query = options.to_query
      uri
    end
  end
end