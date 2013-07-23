class ImageService
  class << self

    def transform(options)
      add_retina options
      add_size options
      "#{self.url}/transform?#{options.to_query}"
    end

    def url
      "http://image-service.#{Rails.env}.dbg.westfield.com"
    end

  private

    def add_size(options)
      width = options.delete(:width)
      height = options.delete(:height)
      options[:size] = "#{width || height || 100}x#{height || width || 100}"
    end

    def add_retina(options)
      if options.delete(:retina)
        options[:height] = options[:height].to_i * 2 if options[:height]
        options[:width] = options[:width].to_i * 2 if options[:width]
        # TODO: Get image service accpet quality
        # options[:quality] ||= 25
      end
    end

  end
end