module ProductsHelper

  # TODO: Delete 'type' and use sub_category instead once product search api
  # facets on sub_category correctly. Alternatively, make it appear anyway.
  def category_facet_tag facets
    category = %w(type sub_category category super_cat).detect {|c| facets.send(c).present? }
    category_facet_tag = facet_tag(category, facets, display_name: "Category", multiple: category=='type') if category
  end

  def applied_category_filter_tag(cat_name,applied_filters)
    return unless cat = applied_filters.categories[cat_name]
    link = link_to cat.title, '#', data: {'category-type' => cat.type,
      'category-code' => cat.value}, class: 'applied_filter'
  end

  def chosen_select_tag(tag_name, values, selected, display_name: nil, class_name: nil, **opts)
    select_tag tag_name, options_for_select(values, selected),
      opts.merge(class: ["chzn-select",class_name].compact.join(" "),
      'data-placeholder' => display_name || "#{tag_name}".titleize.pluralize)
  end

  def facet_values(facet_name, facets)
    facets.send(facet_name)[:values].map do |facet|
      [facet.name.titleize, facet.code]
    end
  end

  def facet_tag(facet_name, facets, display_name: nil, multiple: false)
    return nil if facets.send(facet_name).nil?
    tag_name = multiple ? "#{facet_name}[]" : facet_name
    values = facet_values(facet_name, facets)
    chosen_select_tag tag_name, values, params[facet_name], include_blank: true,
      display_name: display_name || "#{facet_name}".titleize.pluralize,
      multiple: multiple, class_name: "facet-#{facet_name}"
  end
end
