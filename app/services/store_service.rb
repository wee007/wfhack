class StoreService
  class << self
    include ApiClientRequests

    def build(resp)
      json = resp.respond_to?(:body) ? resp.body : resp
      if json.is_a? Array
        json.map{|store| Store.new(store) }
      else
        Store.new(json)
      end
    end

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
