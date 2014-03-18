class CurationService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)
      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('canned-search')}/curations/#{options}.json")
      else
        uri = URI("#{ServiceHelper.uri_for('canned-search')}/curations.json")
        uri.query = options.to_query if options.present?
        uri
      end
    end

    def build(json_response, options = {})
      response = super(json_response)
      response = response.respond_to?(:data) ? response.data : response

      if response.is_a? Array
        response.map { |curation| Curation.new curation.merge(options) }
      else
        Curation.new response.merge(options)
      end
    end

  end
end

