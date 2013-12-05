module ProductsHelper

  # This controller is either scoped by a centre or not,
  # a simple helper to tidy the views
  def pb_path
    (@centre.nil?) ? products_path : centre_products_path(@centre)
  end

  def canonical_url
    centre_category or
      centre_super_cat or
      centre_products or
      products_category or
      products_super_cat or
      products
  end

  def prev_page_url
    url_for(params.merge({page: (@search.page - 1)}))
  end

  def next_page_url
    url_for(params.merge({page: (@search.page + 1)}))
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
end
