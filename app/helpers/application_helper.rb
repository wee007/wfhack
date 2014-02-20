module ApplicationHelper

  def header_hero?
    params[:controller] == 'centres' && params[:action] == "show"
  end

  def site_logo
    svg_with_fallback('logo-beta.svg', alt: 'Westfield')
  end

  def svg_with_fallback(image_src, options = {})
    fallback = File.basename(image_src, '.*') + ".png"
    options.merge!({'data-svg-fallback' => image_path(fallback)})
    image_tag(image_src, options)
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

  def phone_link(phone_number, options = {})
    tel = (phone_number || '').gsub(/\D+/, '')
    options.merge! href: "tel:#{tel}"
    content_tag :a, options do
      yield phone_format(tel)
    end
  end

  def twelve_hour_format(time)
    DateTime.parse(time).to_s(:hour_minute_period).lstrip rescue nil
  end

  def to_paragraphs(string)
    string.split("\n").reject{|l| l.blank? }
  end

  def format_day(date, index=0, length=0)
    date.to_date.strftime("%A")[index,length]
  end

  def today?(date)
    date == Time.now.strftime("%Y-%m-%d")
  end

  def active_link?( string, param )
    'is-active' if string.eql?( param )
  end

  def controller_and_action
    "#{params[ :controller ]}-#{params[ :action ]}".gsub '_', '-'
  end

  def page_title
    meta.page_title.present? ? meta.page_title.html_safe : 'Shopping at Westfield'
  end

end
