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

private

  def get_centre
    centre_service = CentreService.fetch(centre_id)
    CentreService.build centre_service
  end

end
