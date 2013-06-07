class StoreService
  class << self
    include ApiClientRequests

    def request_uri(options=nil)

      if options.is_a?(Fixnum) || options.is_a?(String)
        URI("#{ServiceHelper.uri_for('store')}/stores/#{options}.json")
      elsif options.present?
        uri = URI("#{ServiceHelper.uri_for('store')}/stores.json")
        uri.query = options.to_query
        uri
      else
        URI("#{ServiceHelper.uri_for('store')}/stores.json")
      end

    end
  end
end
