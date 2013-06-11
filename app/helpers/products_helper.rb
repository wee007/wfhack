module ProductsHelper
  def facet_tag(facet_name, facets, display_name=nil)
    return nil if facets.send(facet_name).nil?
    select_tag "#{facet_name}[]",
      options_for_select(facets.send(facet_name)[:values].map do |facet|
        [facet.name.titleize, facet.code]
      end, params[facet_name]),
      include_blank: true, class: 'chzn-select', multiple: true,
      'data-placeholder' => display_name || "#{facet_name}".titleize.pluralize
  end
end
