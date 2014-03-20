module SearchHelper

  def build_url(centre, kind, attributes)
    if attributes.path
      attributes.path
    else
      action = attributes[:action] || 'show'
      action = centre ? 'index_centre' : 'index_national' if kind == 'products'
      attributes.merge!({controller: kind, action: action})
      attributes.merge!({centre_id: centre}) if centre
      url_for attributes
    end
  end

  def has_result_type?(results, result_type)
    results.any? {|result| result.result_type == result_type}
  end

end