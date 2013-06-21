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
  end
end
