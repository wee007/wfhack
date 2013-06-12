module ProductsHelper

  # TODO: Delete 'type' and use sub_category instead once product search api
  # facets on sub_category correctly. Alternatively, make it appear anyway.
  def category_facet_tags facets
    super_cat_tag = hidden_field_tag :super_cat, params[:super_cat] if params[:super_cat].present?
    category_tag = hidden_field_tag :category, params[:category] if params[:category].present?
    sub_category_tag = hidden_field_tag :sub_category, params[:sub_category] if params[:sub_category].present?
    category = %w(type sub_category category super_cat).detect {|c| facets.send(c).present? }
    category_facet_tag = facet_tag(category, facets, display_name: "Category", multiple: category=='type') if category
    [super_cat_tag, category_tag, sub_category_tag, category_facet_tag].compact.join.html_safe
  end

  def facet_tag(facet_name, facets, display_name: nil, multiple: false)
    return nil if facets.send(facet_name).nil?
    tag_name = multiple ? "#{facet_name}[]" : facet_name
    select_tag tag_name,
      options_for_select(facets.send(facet_name)[:values].map do |facet|
        [facet.name.titleize, facet.code]
      end, params[facet_name]),
      include_blank: true, class: "chzn-select facet-#{facet_name}", multiple: multiple,
      'data-placeholder' => display_name || "#{facet_name}".titleize.pluralize
  end
end
