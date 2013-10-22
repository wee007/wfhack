class Store < Hashie::Mash

  def first_letter
    letter = name.strip.first.capitalize
    if letter.match(/^[[:alpha:]]$/)
      letter
    else
      '#'
    end
  end

  def accepts_giftcard?
    false
  end

  def has_logo?
    logo.present?
  end

  def logo
    _links.logo.href
  end

  def has_storefront?
    storefront.present?
  end

  def storefront
    _links.store_front.href
  end

  def centre=(centre)
    @centre = centre
  end

  def centre
    @centre ||= get_centre
  end

  def closing_time
    if today_closing_time.present?
      today_closing_time
    elsif centre.present? && centre.today_closing_time.present?
      centre.today_closing_time
    else
      nil
    end
  end

  def closing_time_12
    DateTime.parse(closing_time)
      .strftime('%l:%M%P')
      .lstrip rescue nil
  end

  def to_gon
    gon = {
      id: id,
      name: name,
      url: url,
      storefront_path: Rails.application.routes.url_helpers.centre_store_path(centre_id, retailer_code, id),
      micello_geom_id: micello_geom_id,
      closing_time_24: closing_time,
      closing_time_12: closing_time_12
    }
    gon[:logo] = logo if has_logo?
    gon
  end

private

  def get_centre
    centre_service = CentreService.fetch(centre_id)
    CentreService.build centre_service
  end

end
