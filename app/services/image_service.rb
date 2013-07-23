class ImageService
  class << self

    def transform(options)
      add_responsive options
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

    def add_responsive(options)
      if options.delete(:responsive)
        options[:height] = options[:height].to_i * 2 if options[:height]
        options[:width] = options[:width].to_i * 2 if options[:width]
        options[:quality] ||= 25
      end
    end

  end
end