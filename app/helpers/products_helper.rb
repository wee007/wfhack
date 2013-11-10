module ProductsHelper

  # This controller is either scoped by a centre or not,
  # a simple helper to tidy the views
  def pb_path
    (@centre.nil?) ? browse_path : centre_browse_path(@centre)
  end


  def facet_remove_link(filter, value)
    url_params = params.dup
    if url_params[filter].is_a? Array
      url_params[filter] = url_params[filter] - [value]
    else
      url_params.delete filter
    end
    if %w(super_cat category).include? filter
      %w(colour size sub_category type).each {|f| url_params.delete f}
    end
    url_params.delete 'category' if filter == 'super_cat'
    url_params.delete_if {|k,v| v.blank? || v.is_a?(Array) && v.all?(&:blank?)}
    centre_browse_path(url_params)
  end

end
