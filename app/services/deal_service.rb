class DealService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('deal')}/deals/#{options}.json")
      elsif options.present?
        uri = URI("#{ServiceHelper.uri_for('deal')}/deals.json")
        uri.query = options.to_query
        uri
      else
        URI("#{ServiceHelper.uri_for('deal')}/deals.json")
      end

    end

    def build(json_response)
      return Deal.new(super(json_response)) unless super(json_response).is_a?(Array)
      super(json_response).map do |deal_json|
        Deal.new(deal_json)
      end
    end
  end
end
