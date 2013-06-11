class StreamService
  class << self
    include ApiClientRequests
    def build(response)
      body = response.is_a?(Faraday::Response) ? response.body : response
      if body.is_a? Hash
        body['stream']
      else
        []
      end
    end

    def request_uri(options={})
      uri = ServiceHelper.uri_for('stream')
      if options[:stream]
        uri.path += "/#{options.delete :stream}_stream.json"
      else
        uri.path += '/stream.json'
      end
      uri.query = options.to_query
      uri
    end
  end
end
