class StreamService

  TYPE_CLASSES = {
    "product" => Product,
    "event" => Event,
    "deal" => Deal,
    "canned_search" => CannedSearch,
    "curation" => Curation
  }

  class << self
    
    include ApiClientRequests

    def build(response, options ={})
      body = response.is_a?(Faraday::Response) ? response.body : response
      stream = body.is_a?(Hash) ? body['stream'] : []
      stream.map do |result|
        TYPE_CLASSES[result["type"]].new(result.merge(options)) if TYPE_CLASSES.keys.include?(result["type"])
      end.flatten.compact
    end

    def request_uri(options={})
      uri = ServiceHelper.uri_for('stream',  protocol = 'http', host: :external)
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
