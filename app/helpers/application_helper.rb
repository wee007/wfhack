module ApplicationHelper

  def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
  end

  def site_logo
    image_tag('logo.svg', alt: 'Westfield', 'data-svg-fallback' => image_path("logo.png"))
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

  def phone_format(phone_no)
    phone_no = phone_no || ''
    if phone_no.match /^02|^03|^06|^07|^08/
      phone_no.gsub(/^(\d{2})(\d{4})(\d*)$/, '\1 \2 \3')
    elsif phone_no[0] == '1' && phone_no.length == 10
      phone_no.gsub(/^(\d{4})(\d{3})(\d*)$/, '\1 \2 \3')
    elsif phone_no[0] == '1' && phone_no.length == 6
      phone_no.gsub(/^(\d{3})(\d*)$/, '\1 \2')
    elsif phone_no.match /^04/
      phone_no.gsub(/^(\d{4})(\d{3})(\d*)$/, '\1 \2 \3')
    else
      phone_no
    end
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
