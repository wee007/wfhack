class CentreServiceNoticeService
  class << self
    include ApiClientRequests

    def build(json)
      body = json.respond_to?(:body) ? json.body : json
      Notice.build(body)
    end

    def request_uri(options = nil)
      # if options is numeric, then we search by the given id value
      if (options.to_s =~ /\A[+-]?\d+\Z/)
        uri = URI("#{ServiceHelper.uri_for('centre', protocol = 'https', host: :external)}/notices/#{options}.json")
      else
        # options was not numeric
        uri = URI("#{ServiceHelper.uri_for('centre', protocol = 'https', host: :external)}/notices.json")
        uri.query = options.to_query if options.present?
      end
      uri
    end

  end
end
