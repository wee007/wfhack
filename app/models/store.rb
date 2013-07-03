require 'hashie'

class Store < Hashie::Mash

  def first_letter
    letter = name.strip.first.capitalize
    if letter.match(/^[[:alpha:]]$/)
      letter
    else
      '#'
    end
  end

  def logo
    _links.logo.href
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
