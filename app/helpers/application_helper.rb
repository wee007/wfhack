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
    asset_path 'placeholder.png'
  end

  def current_url
    "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end

  def parent_layout(layout)
    @view_flow.set(:layout,output_buffer)
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  def twelve_hour_format(time)
    DateTime.parse(time)
      .strftime('%l:%M%P')
      .lstrip rescue nil
  end

end