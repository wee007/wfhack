module ProductsHelper

  def products_sort_tag(sort_options)
    default = ["","", {'data-sort-link' => centre_products_path(params.reject{|k,v|k=='sort'})}]
    values = sort_options.select{|s| s[:display]}.map do |s|
      [s.description, s.code, {'data-sort-link' => centre_products_path(params.merge sort: s.code)}]
    end
    selected = params[:sort]
    select_tag(:sort, options_for_select([default]+values, selected), include_blank: false)
  end

  def price_tag(product)
    if product.is_discounted
      content_tag :p, class: 'price' do
        was = content_tag(:del,number_to_currency(product.display_price))
        now = content_tag(:span, number_to_currency(product.display_sale_price), class: 'sale')
        "#{was} #{now}".html_safe
      end
    else
      content_tag :p do
        content_tag(:span, number_to_currency(product.display_price))
      end
    end
  end

end
