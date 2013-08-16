class Store < Hashie::Mash

  def first_letter
    letter = name.strip.first.capitalize
    if letter.match(/^[[:alpha:]]$/)
      letter
    else
      '#'
    end
  end

  def logo_ref
    _links.logo.ref
  end

  def has_logo?
    logo_ref.present?
  end

  def logo(options = {})
    options.merge!({ref: logo_ref})
    ImageService.transform options
  end

  def store_front_image_url
    _links.store_front.href
  end

  def centre
    @centre ||= get_centre
  end

private

  def get_centre
    centre_service = CentreService.fetch(centre_id)
    CentreService.build centre_service
  end

end
