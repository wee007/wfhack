class CentreService
  class << self
    def build(json_response)
      json_response.body
    end

    def request_uri(centre=nil)
      if centre.present?
        URI("#{ENV['HOST']}/api/centre/master/centres/#{centre}.json")
      else
        URI("#{ENV['HOST']}/api/centre/master/centres.json")
      end
    end
  end
end
