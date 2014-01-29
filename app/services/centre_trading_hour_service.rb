class CentreTradingHourService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      body.map{|hour_data| CentreTradingHour.new(hour_data)}
    end

    def request_uri(centre=nil, options={})
      uri = URI("#{ServiceHelper.uri_for('trading-hour')}/centre_trading_hours/range.json")
      uri.query = {centre_id: centre}.merge(options).to_query
      uri
    end
  end
end
