module ApplicationHelper

	def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
	end

  def in_lightbox?
    false #TODO Add logic here to check if we are in a lightbox.
  end

  def page? page
    params[:controller] == page.to_s ? 'is-active' : nil
  end

  def responsive_image_tag(options = {})
    src = options.delete(:placeholder) || default_placeholder_image
    options[:data] = { :src => options.delete(:normal) }
    if options.has_key? :retina
      options[:data][:'src-retina'] = options.delete(:retina)
    end
    image_tag(src, options) + content_tag(:noscript) do
      image_tag options[:data][:src]
    end
  end

  def default_placeholder_image
    protocol = 'http://'
    image_service = "image-service.#{Rails.env}.dbg.westfield.com"
    customer_console = "customer-console.#{Rails.env}.dbg.westfield.com"
    image = "assets/logo-tile.png"
    attr = "size=60x60&pad=true&background=ffffff"
    protocol + image_service + '/transform?url=' + protocol + customer_console + '/' + image + '&' + attr
  end

end
