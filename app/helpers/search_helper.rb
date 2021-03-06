module SearchHelper

  def build_url(centre, kind, attributes, params = {})
    url = _build_url(centre, kind, attributes)
    if params != {}
      params.each do |key, value|
        urlJoiner = (url.include?('?') ? '&' : '?')
        url = url + urlJoiner + key.to_s + "=" + value
      end
    end
    url
  end

  def has_result_type?(results, result_type)
    results.any? {|result| result.result_type == result_type}
  end

  def has_category_results?(results)
    results.any? {|result| result.attributes.category.present?}
  end

  def results_by_type(results, result_type)
    results.select {|result| result.result_type == result_type}
  end

  def number_of_results(results)
    results.count {|result| result.result_type != 'product_brand' and result.result_type != 'retail_chain'}
  end

  def map_type_to_css_icon result_type
    "icon--" + begin
      case result_type
      when 'centre_information'
        'info'
      when 'centre_service'
        'service'
      else
        result_type.singularize
      end
    end
  end

  private

  def _build_url(centre, kind, attributes)
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

end