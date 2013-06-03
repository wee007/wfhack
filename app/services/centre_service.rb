class CentreService
  class << self

    def find(centre)
      fetch.body
    end

    def fetch(centre)
      Service::API.get request_uri(centre)
    end

    def request_uri(centre)
      URI("#{ENV['HOST']}/api/centre/master/centres/#{centre}.json")
    end
  end
end
