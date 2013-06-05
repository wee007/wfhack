class CentreService
  class << self
    include ApiClientRequests

    def request_uri(centre=nil)
      if centre.present?
        URI("http://centre-service.#{AppConfig.service_host}/api/centre/master/centres/#{centre}.json")
      else
        URI("http://centre-service.#{AppConfig.service_host}/api/centre/master/centres.json")
      end
    end
  end
end
