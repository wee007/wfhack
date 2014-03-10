module SearchHelper

  def build_url(centre, kind, attributes)
    if attributes.path
      attributes.path
    else
      action = 'show'
      action = centre ? 'index_centre' : 'index_national' if kind == 'products'
      attributes.merge!({controller: kind, action: action})
      attributes.merge!({centre_id: centre}) if centre
      url_for attributes
    end
  end

end