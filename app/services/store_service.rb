class StoreService
  class << self
    include ApiClientRequests

    def build(resp, attrs = {})
      json = resp.respond_to?(:body) ? resp.body : resp
      if json.is_a? Array
        json.map do |store|
          store = Store.new(store)
          attrs.each do |key, value|
            store.send("#{key}=", value)
          end if attrs.present?
          store
        end
      else
        store = Store.new(json)
        attrs.each do |key, value|
          store.send("#{key}=", value)
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
    def cinema_id_for_centre(centre_id)
      # centre_id: store_id / cinema_id
      {
        belconnen: 17453,
        parramatta: 28390,
        marion: 17306,
        strathpine: 494,
        doncaster: 38032,
        mtdruitt: 5072,
        whitfordcity: 21823,
        teatreeplaza: 3694,
        westlakes: 22922,
        southland: 3341,
        woden: 25682,
        gardencity: 18722,
        burwood: 656,
        carindale: 5463,
        chermside: 1173,
        eastgardens: 4863,
        bondijunction: 22739,
        penrith: 24757,
        tuggerah: 2414,
        hurstville: 4117,
        warringahmall: 48969,
        liverpool: 3106,
        chatswood: 1696,
        warrawong: 526,
        airportwest: 6,
        miranda: 15809,
        hornsby: 1435,
        carousel: 890,
        knox: 48555,
        fountaingate: 4573
      }[centre_id.to_sym]
    end
  end
end
