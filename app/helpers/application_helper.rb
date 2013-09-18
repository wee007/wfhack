module ApplicationHelper

  def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
  end

  def in_lightbox?
    false #TODO Add logic here to check if we are in a lightbox.
  end

  def page? page
    params[:controller] == page.to_s
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

  def to_paragraphs(string)
    string.split("\n").reject{|l| l.blank? }
  end

end