class ProductsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, centres, nearby_centres, products, super_categories, stores = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id] if params[:centre_id]
      nearby_centres = CentreService.fetch nil, near_to: params[:centre_id] if params[:centre_id]
      centres = CentreService.fetch :all, country: 'au' unless params[:centre_id]
      products = ProductService.fetch params.merge({rows: 50})
      stores = StoreService.fetch retailer_code: params[:retailer].first if params[:retailer]
    end

    super_categories = CategoryService.fetch centre_id: params[:centre_id], product_mapable: true if params[:centre_id]

    if params[:centre_id]
      @centre = CentreService.build centre
      @nearby_centres = CentreService.build nearby_centres

      stores = StoreService.build stores, centre_id: params[:centre_id] if stores.present?

      meta.push(
        page_title: page_title(@centre.name),
        description: description(@centre.name, stores)
      )
    else
      @centres = CentreService.group_by_state centres

      stores = StoreService.build stores if stores.present?

      meta.push(
        page_title: page_title('Westfield'),
        description: description('Westfield', stores)
      )
    end
    @search = ProductService.build products
    @super_categories = CategoryService.build super_categories

    @pagination = {
      page: (params[:page] || 1).to_i,
      page_count: (@search['count'].to_f / @search['rows'].to_f).ceil
    }

    respond_to do |format|
      if request.xhr?
        # This should be its own route? There is alot of stuff above it does not need.
        format.html { render partial: "products" }
      else
        gon.products = {
          display_options: @search.display_options,
          facets: @search.facets,
          applied_filters: @search.applied_filters
        }
        format.html { render :index }
      end
    end
  end


  def show
    centre, centres, product, stores = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id] if params[:centre_id]
      centres = CentreService.fetch :all, country: 'au' unless params[:centre_id]
      product = ProductService.fetch params[:id]
      stores = StoreService.fetch retailer_code: params[:retailer_code], per_page: 50
    end

    @product = ProductService.build product

    meta.push @product.meta

    if params[:centre_id]
      stores = StoreService.build(stores)
      centre_ids = stores.map(&:centre_id).uniq
      @centre_stores = stores.select {|store| store['centre_id'] == params[:centre_id]}
      @product_centres = centre_ids.present? ? CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id]) : []
      @centre = CentreService.build centre
      gon.push centre: @centre
      meta.push(
        title: "#{@product.name} from #{stores.first.try(:name)}",
        twitter_title: "What do you think of #{@product.name} from #{stores.first.try(:name)}?",
        page_title: "#{@product.name} | #{@centre.name}",
        description: "Shop for #{@product.name} from #{stores.first.try(:name)} at #{@centre.name}"
      )
      @product_redirection_url = url_for centre_product_redirection_url
    else
      @centres = CentreService.group_by_state centres

      meta.push(
        page_title: @product.name,
        description: @product.name
      )
      @product_redirection_url = url_for product_redirection_url
    end
  end


  def redirection
    @product = ProductService.find params[:id]

    @cam_ref = @product.retail_chain.cam_ref

    if @cam_ref.present?
      ad_ref = @product.categories[0].super_category.code

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
      "#{params[:retailer].map{ |param| param.titleize }.join(' and ')} at #{centre_name}"
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
