require 'uri'
require 'app_config'

class Store

  def self.get
    url = URI.parse AppConfig.store_service_url
    host = url.host
    host = host << ":#{url.port}" if url.port

    conn = Faraday.new(url: "#{url.scheme}://#{host}") do |faraday|
      faraday.adapter Faraday.default_adapter
    end

    response = conn.get url.path
    JSON.parse(response.body).map { |store| OpenStruct.new store }
  end

end
