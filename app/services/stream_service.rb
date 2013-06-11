class StreamService
  class << self
    include ApiClientRequests
    def build(json)
      json.respond_to?(:body) ? json.body['stream'] : json['stream']
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
