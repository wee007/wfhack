class Store < Hashie::Mash

  def first_letter
    letter = name.strip.first.capitalize
    if letter.match(/^[[:alpha:]]$/)
      letter
    else
      '#'
    end
  end

  def to_partial_path
    'store'
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

  def opening_time
    todays_hours.opening_time
  end

  def closing_time
    todays_hours.closing_time
  end

  def closed_today
    todays_hours.closed?
  end

  def closing_time_12
    DateTime.parse(closing_time)
      .strftime('%l:%M%P')
      .lstrip rescue nil
  end

  def this_sunday
    this_monday = Date.commercial(Date.today.year, Date.today.cweek, 1).in_time_zone(centre.timezone)
    (this_monday+6.days).strftime("%Y-%m-%d")
  end

  def to_gon
    gon = {
      id: id,
      name: name,
      url: url,
      storefront_path: Rails.application.routes.url_helpers.centre_store_path(centre_id, retailer_code, id),
      micello_geom_id: micello_geom_id,
      closing_time_24: closing_time,
      closing_time_12: closing_time_12,
      closed_today: closed_today
    }
    gon[:logo] = logo if has_logo?
    gon
  end

private

  def get_centre
    centre_service = CentreService.fetch(centre_id)
    CentreService.build centre_service
  end

  def todays_hours
    today = Time.now.in_time_zone(centre.timezone).strftime("%Y-%m-%d")
    @todays_hours ||= StoreTradingHourService.find({store_id:id, centre_id: centre_id, from: today, to: today}).first
  end

end
