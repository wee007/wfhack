class StoreService
  class << self
    include ApiClientRequests

    def build(resp, attrs = {})
      json = resp.respond_to?(:body) ? resp.body : resp
      if json.is_a? Array
        json.map do |store|
          store = Store.new(store)
          attrs.each do |key, value|
            store[key] = value
          end if attrs.present?
          store
        end
      else
        store = Store.new(json)
        attrs.each do |key, value|
          store[key] = value
        end if attrs.present?
        store
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

    # This is only here because the category service doesn't exist yet,
    # so I can't find out the Cinema category and then filter by that.
    # Remove this once all that is done.
    def fetch_cinema_for_centre(centre_id)
      cinema = [
        {cinema_id: 17453, centre_id: 'belconnen'},
        {cinema_id: 28390, centre_id: 'parramatta'},
        {cinema_id: 17306, centre_id: 'marion'},
        {cinema_id:   494, centre_id: 'strathpine'},
        {cinema_id: 38032, centre_id: 'doncaster'},
        {cinema_id:  5072, centre_id: 'mtdruitt'},
        {cinema_id: 21823, centre_id: 'whitfordcity'},
        {cinema_id:  3694, centre_id: 'teatreeplaza'},
        {cinema_id: 22922, centre_id: 'westlakes'},
        {cinema_id:  3341, centre_id: 'southland'},
        {cinema_id: 25682, centre_id: 'woden'},
        {cinema_id: 18722, centre_id: 'gardencity'},
        {cinema_id:   656, centre_id: 'burwood'},
        {cinema_id:  5463, centre_id: 'carindale'},
        {cinema_id:  1173, centre_id: 'chermside'},
        {cinema_id:  4863, centre_id: 'eastgardens'},
        {cinema_id: 22739, centre_id: 'bondijunction'},
        {cinema_id: 24757, centre_id: 'penrith'},
        {cinema_id:  2414, centre_id: 'tuggerah'},
        {cinema_id:  4117, centre_id: 'hurstville'},
        {cinema_id: 48969, centre_id: 'warringahmall'},
        {cinema_id:  3106, centre_id: 'liverpool'},
        {cinema_id:  1696, centre_id: 'chatswood'},
        {cinema_id:   526, centre_id: 'warrawong'},
        {cinema_id:     6, centre_id: 'airportwest'},
        {cinema_id: 15809, centre_id: 'miranda'},
        {cinema_id:  1435, centre_id: 'hornsby'},
        {cinema_id:   890, centre_id: 'carousel'},
        {cinema_id: 48555, centre_id: 'knox'},
        {cinema_id:  4573, centre_id: 'fountaingate'},
        {cinema_id: 50141, centre_id: 'knox'}
      ].find{|cinema_and_centre| cinema_and_centre[:centre_id] == centre_id}

      fetch(cinema[:cinema_id]) if cinema
    end
  end
end
