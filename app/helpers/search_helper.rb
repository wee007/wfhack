module SearchHelper

  def build_url(centre, kind, attributes)
    if attributes.path
      attributes.path
    else
      action = attributes[:action] || 'show'
      action = centre ? 'index_centre' : 'index_national' if kind == 'products'
      action = 'show' if kind == 'centre_hours' || kind == 'centre_info' || kind == 'centre_service_details'
      attributes.merge!({controller: kind, action: action})
      attributes.merge!({centre_id: centre}) if centre
      url_for attributes
    end
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

end