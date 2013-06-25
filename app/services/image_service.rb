class ImageService
  class << self

    def transform(options)
      "#{self.url}/transform?#{options.to_query}"
    end

    def url
      "http://image-service.#{Rails.env}.dbg.westfield.com"
    end

  end
end