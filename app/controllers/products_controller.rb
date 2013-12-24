class ProductsController < ApplicationController

  layout 'detail_view', only: [:show_centre, :show_national]

  def index_centre
    services = {
      centre: params[:centre_id],
      centres: [nil, {near_to: params[:centre_id]}],
      products: params.merge({rows: 50})
    }
    services[:store] = {retailer_code: params[:retailer].first} if params[:retailer]
    @centre, @nearby_centres, @search, stores = service_map services
    @super_categories = CategoryService.find centre_id: params[:centre_id], product_mapable: true

    meta.push(
      page_title: page_title(@centre.name),
      description: description(@centre.name, stores)
    )

    gon.products = {
      display_options: @search.display_options,
      facets: @search.facets,
      applied_filters: @search.applied_filters
    }

    render :index
  end

  def index_national
    services = { centre: [:all, country: 'au'], products: params.merge({rows: 50}) }
    services[:store] = {retailer_code: params[:retailer].first} if params[:retailer]
    centres, @search, stores = service_map services

    @centres = centres.group_by{ |centre| centre.state }

    meta.push(
      page_title: page_title('Westfield'),
      description: description('Westfield', stores)
    )

    gon.products = {
      display_options: @search.display_options,
      facets: @search.facets,
      applied_filters: @search.applied_filters
    }

    render :index
  end

  # Does not need all the extra stuff a normal index pages needed
  def index_xhr
    @search = ProductService.find params.merge({rows: 50})
    render partial: "products"
  end

  def show_centre
    @centre, @product, stores = service_map \
      centre: params[:centre_id],
      product: params[:id],
      store: {retailer_code: params[:retailer_code], per_page: 50}

    centre_ids = stores.map(&:centre_id).uniq
    @centre_stores = stores.select {|store| store.centre_id == params[:centre_id]}

    @product_centres = []
    if centre_ids.present?
      @product_centres = CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id])
    end

    gon.push centre: @centre

    meta.push @product.meta
    meta.push(
      page_title: "#{@product.name} | #{@centre.name}",
      description: "Shop for #{@product.name} from #{stores.first.try(:name)} at #{@centre.name}",
      title: "#{@product.name} from #{stores.first.try(:name)}",
      twitter_title: "What do you think of #{@product.name} from #{stores.first.try(:name)}?"
    )
    @product_redirection_url = url_for centre_product_redirection_url

    render :show
  end

  def show_national
    centres, @product, @stores = service_map \
      centre: [:all, {country: 'au'}],
      product: params[:id],
      store: {retailer_code: params[:retailer_code], per_page: 50}

    @centres = centres.group_by{ |centre| centre.state }

    meta.push @product.meta
    meta.push(
      page_title: @product.name,
      description: @product.name
    )
    @product_redirection_url = url_for product_redirection_url

    render :show
  end

  def redirection
    @product = ProductService.find params[:id]

    @cam_ref = @product.retail_chain.cam_ref

    if @cam_ref.present?
      ad_ref = @product.categories.try('[]', 0).try(:super_category).try(:code) || ''

      # FIXME: Needed once authentication installed
      # customer_id = cas_session.user_id
      customer_id = ""
      request_url = request.url.split("/redirection")[0]

      pub_ref = [
        request_url,
        request.remote_ip,
        customer_id,
      ].join("%7C")

      pub_ref += "%7C%7C%7C"  # placeholders for utm data

      product_tracking_url =
        "http://prf.hn/click/camref:#{@cam_ref}/pubref:#{pub_ref}/adref:#{ad_ref}/" \
        "destination:#{@product.primary_retailer_product_url}"
    else  # missing cam_ref should be rare
      product_tracking_url = @product.primary_retailer_product_url
      logger.warn("CAMREF_MISSING product_sku=#{@product.sku} " \
        "retailer_code=#{@product.retailer_code}")
    end

    meta.push(
      retail_chain_name: @product.retail_chain_name,
      page_title: "#{@product.retail_chain_name} - #{@product.name}",
      product_tracking_url: product_tracking_url
    )
    render layout: 'base'
  end

private

  def page_title(centre_name)
    if category_params.present?
      "Buy #{category_params} online at #{centre_name}"
    elsif params[:retailer].present?
      "#{[params[:retailer]].flatten.map{ |param| param.titleize }.join(' and ')} at #{centre_name}"
    else
      "Shopping at #{centre_name}"
    end
  end

  def description(centre_name, stores)
    if category_params.present?
      "Browse the latest #{category_params} online at #{centre_name}"
    elsif stores.present?
      stores.first.description.try(:truncate, 156)
    else
      "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at #{centre_name}"
    end
  end

  def category_params
    if params[:sub_category].present? || params[:category].present? || params[:super_cat].present?
      categories = params[:sub_category] || params[:category] || params[:super_cat]
      [categories].flatten.map{ |param| param.titleize }.join(' and ')
    end
  end

end
