module ProductsHelper

  # This controller is either scoped by a centre or not,
  # a simple helper to tidy the views
  def pb_path
    (@centre.nil?) ? products_path : centre_products_path(@centre.code)
  end

  # Build category canonical URL for JS disabled site.
  # TODO: Consolidate `nonscript_category_canonical_url` and `category_canonical_url` into one method.
  #       The challenge is that both methods are getting the category details from different objects
  #       and are accepting different arguments.
  #       It would be nice to revisit as part of the category rework.
  def noscript_category_canonical_url(categories)
    if categories.sub_category.present?
      url_for(params: {'sub_category' => categories.sub_category})
    else
      build_category_url(categories.super_cat, categories.category, nil)
    end
  end

  def category_canonical_url(category_count=0)
    category_code = @product.category_hierarchy.map{ |c| c.code }
    (super_category, category, sub_category) = category_code.first(category_count+1)
    build_category_url(super_category, category, sub_category)
  end

  def retailer_canonical_url
    return "#{centre_products_url(@centre)}?retailer=#{@product.retailer_code}" if @centre.present?
    "#{products_url}?retailer=#{@product.retailer_code}"
  end

  def prev_page_url
    url_for pagination_params @search.page - 1
  end

  def next_page_url
    url_for pagination_params @search.page + 1
  end

  def pagination_params(page)
    params_dup = params.dup
    params_dup[:centre_id] = params_dup[:current_centre] if params_dup[:current_centre].present?
    params_dup[:action] = params_dup[:centre_id] ? 'index_centre' : 'index_national'
    params_dup[:page] = page
    params_dup
  end

  def national_product_index?
    params[:controller] == 'products' &&
    params[:action] == 'index_national'
  end

  def national_products?
    national? &&
    params[:controller] == 'products'
  end

  private

  def build_category_url(super_category, category, sub_category)
    case
    when sub_category.present?
      return "#{centre_products_category_url(@centre, super_category, category)}?sub_category=#{sub_category}" if @centre.present?
      "#{products_category_url(super_category, category)}?sub_category=#{sub_category}"
    when category.present?
      return centre_products_category_url(@centre, super_category, category) if @centre.present?
      products_category_url(super_category, category)
    else
      return centre_products_super_cat_url(@centre, super_category) if @centre.present?
      products_super_cat_url(super_category)
    end
  end
end
