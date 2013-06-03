class CentreService
  class << self
    include ApiClientRequests

    def request_uri(centre=nil)
      if centre.present?
        URI("#{ENV['HOST']}/api/centre/master/centres/#{centre}.json")
      else
        URI("#{ENV['HOST']}/api/centre/master/centres.json")
      end
    end
  end
end
