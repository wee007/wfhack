class CentreServiceNoticesService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      Notice.build(body)
    end

    def request_uri(options = nil)
      # if options is numeric, then we search by the given id value
      if (options.to_s =~ /\A[+-]?\d+\Z/)
        uri = URI("#{ServiceHelper.uri_for('centre')}/notices/#{options}.json")
      elsif options.present?
        # options was not numeric
        uri = URI("#{ServiceHelper.uri_for('centre')}/notices.json")
        uri.query = options.to_query 
      else
        uri = URI("#{ServiceHelper.uri_for('centre')}/notices.json")
      end

      uri
    end

  end
end
