module ProductsHelper

  # This controller is either scoped by a centre or not,
  # a simple helper to tidy the views
  def pb_path
    (@centre.nil?) ? products_path : centre_products_path(@centre.code)
  end

  def canonical_url
    centre_category or
      centre_super_cat or
      centre_products or
      products_category or
      products_super_cat or
      products
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

  def build_store_centres(stores, centres)
    store_centre_ids = stores.map{ |store| store.centre_id }
    centres.select{ |centre| store_centre_ids.include?(centre.code) }.group_by{ |centre| centre.state }
  end

  private

  def centre_category
    centre_products_category_url(params[:centre], params[:super_cat], params[:category], params.except(:centre, :super_cat, :category)) if !params[:super_cat].nil? and !params[:category].nil? and !params[:centre].nil?
  end

  def centre_super_cat
    centre_products_super_cat_url(params[:centre], params[:super_cat], params.except(:centre, :category)) if !params[:super_cat].nil? and !params[:centre].nil?
  end

  def centre_products
    centre_products_url(params[:centre], params.except(:centre)) if !params[:centre].nil?
  end

  def products_category
    products_category_url(params[:super_cat], params[:category], params.except(:super_cat, :category)) if !params[:super_cat].nil? and !params[:category].nil?
  end

  def products_super_cat
    products_super_cat_url(params[:super_cat], params.except(:super_cat)) if !params[:super_cat].nil?
  end

  def products
    products_url(params)
  end

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
