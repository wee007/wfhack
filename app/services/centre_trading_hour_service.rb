class CentreTradingHourService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      CentreTradingHour.build(body)
    end

    def weeks(json)
      # Group hours into weeks then reverse to they are in
      # cronilogical order.
      weeks = build(json).in_groups_of(7, false).reverse

      # Grap the 1st two as we always want them
      output = [weeks.pop, weeks.pop]

      # Keep grabing then next ones if they have christmas hours
      while weeks.length > 0 do
        week = weeks.pop
        output << week if week.find { |hour| hour.christmas? }
      end

      output
    end

    def request_uri(centre=nil, options={})
      if centre.nil? || centre == :all
        uri = URI("#{ServiceHelper.uri_for('centre')}/trading_hours.json")
      else
        uri = URI("#{ServiceHelper.uri_for('centre')}/trading_hours/#{centre}/range.json")
      end
      uri.query = options.to_query
      uri
    end
  end
end
