class CentreTradingHourService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      if body.size > 1
        weeks = body.map{|hour_data| CentreTradingHour.new(hour_data)}.in_groups_of(7).reverse
        [weeks.pop, weeks.pop]
      else
        CentreTradingHour.new(body.first)
      end
    end

    def request_uri(centre=nil, options={})
      uri = URI("#{ServiceHelper.uri_for('trading-hour')}/centre_trading_hours/range.json")
      uri.query = {centre_id: centre}.merge(options).to_query
      uri
    end
  end
end
