class ProductsController < ApplicationController

  before_action :remove_gclid_param
  before_action :fetch_service_api_data, only: [:show_centre, :show_national]

  layout 'detail_view', only: [:show_centre, :show_national]

  def index_centre
    services = {
      centre: params[:centre_id],
      centres: [nil, {near_to: params[:centre_id]}],
      products: params.merge({rows: 50})
    }
    services[:store] = {retailer_code: params[:retailer].first} if params[:retailer]

    #BUG: Stores is NEVER assigned to anything.
    @centre, @nearby_centres, @search, stores = service_map services
    @super_categories = CategoryService.find centre_id: params[:centre_id], product_mapable: true

    meta.push(
      page_title: "#{ @search.seo.page_title } at #{ @centre.name }",
      description: "#{ @search.seo.description } at #{ @centre.name }"
    ) if @search.seo.present?

    gon.products = {
      display_options: @search.display_options,
      facets: @search.facets,
      applied_filters: @search.applied_filters,
      count: @search.products.length
    }

    render :index
  end

  def index_national
    services = {
      centre: [:all, country: 'au'],
      products: params.merge({rows: 50})
    }
    services[:store] = {retailer_code: params[:retailer].first} if params[:retailer]
    centres, @search, stores = service_map services

    @centres_by_state = centres.group_by{ |centre| centre.state }
    @super_categories = CategoryService.find centre_id: params[:centre_id], product_mapable: true

    meta.push(
      page_title: "#{ @search.seo.page_title } at Westfield",
      description: "#{ @search.seo.description } at Westfield"
    ) if @search.seo.present?

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
    centre_ids = @stores.map{ |centre| centre.centre_id }.uniq
    @centre_stores = @stores.select{ |store| store.centre_id == params[:centre_id] }
    @centres_by_store = build_centres_by_store(@stores, @centres)

    @product_centres = []
    if centre_ids.present?
      @product_centres = CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id])
    end

    gon.push centre: @centre

    meta.push @product.meta
    meta.push(
      page_title: "#{@product.name} | #{@centre.name}",
      description: "Shop for #{@product.name} from #{@stores.first.name} at #{@centre.name}",
      title: "#{@product.name} from #{@stores.first.name}",
      twitter_title: "What do you think of #{@product.name} from #{@stores.first.name}?"
    )
    @product_redirection_url = url_for centre_product_redirection_url

    render :show
  end

  def show_national
    @centres_by_state = @centres.group_by{ |centre| centre.state }
    @centres_by_store = build_centres_by_store(@stores, @centres)

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

  def remove_gclid_param
    params.delete(:gclid)
  end

  def fetch_service_api_data
    services = {
      centres: [:all, {country: 'au'}],
      product: params[:id],
      store: {retailer_code: params[:retailer_code], per_page: 50}
    }
    services[:centre] = params[:centre_id] if params[:centre_id]

    @centres, @product, @stores, @centre = service_map services
  end

  def build_centres_by_store(stores, centres)
    store_centre_ids = stores.map{ |store| store.centre_id }
    centres.select{ |centre| store_centre_ids.include?(centre.code) }.group_by{ |centre| centre.state }
  end

end
