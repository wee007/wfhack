class CentreService
  class << self
    include ApiClientRequests

    def request_uri(centre=nil)
      if centre.present?
        URI("#{AppConfig.centre_service_url}/centres/#{centre}.json")
      else
        URI("#{AppConfig.centre_service_url}/centres.json")
      end
    end
  end
end
