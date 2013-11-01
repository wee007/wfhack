class ProductsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, centres, nearby_centres, products, super_categories = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id] if params[:centre_id]
      nearby_centres = CentreService.fetch nil, near_to: params[:centre_id] if params[:centre_id]
      centres = CentreService.fetch :all, country: 'au' unless params[:centre_id]
      products = ProductService.fetch params.merge({rows: 50})
    end

    super_categories = CategoryService.fetch centre_id: params[:centre_id], product_mapable: true if params[:centre_id]

    if params[:centre_id]
      @centre = CentreService.build centre
      @nearby_centres = CentreService.build nearby_centres

      meta.push(
        page_title: page_title(@centre),
        description: description(@centre)
      )
    else
      @centres = CentreService.group_by_state centres

      meta.push(
        page_title: "Shopping at Westfield",
        description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at Westfield"
      )
    end
    @search = ProductService.build products
    @super_categories = CategoryService.build super_categories

    categories = @search.facets.detect{|f| ["super_cat", "category", "sub_category"].include? f.field }
    @categories = categories ? categories['values'] : []

    brands = @search.facets.detect{|f| f.field == "brand" }
    @brands = brands ? brands['values'] : []

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
      product = ProductService.fetch params.dup
      stores = StoreService.fetch retailer_code: params[:retailer_code], per_page: 50
    end

    @product = ProductService.build product

    if params[:centre_id]
      stores = StoreService.build(stores)
      centre_ids = stores.map(&:centre_id).uniq
      @centre_stores = stores.select {|store| store['centre_id'] == params[:centre_id]}
      @product_centres = centre_ids.present? ? CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id]) : []
      @centre = CentreService.build centre
      gon.push centre: @centre, stores: @centre_stores.map(&:to_gon)
      meta.push(
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

    meta.push @product.meta
  end


  def redirection
    expires_now
    @product = ProductService.build(ProductService.fetch params.dup.merge({action: 'show'}))

    cam_ref = @product.retail_chain.cam_ref

    if cam_ref
      ad_ref = @product.categories[0].super_category.code

      # FIXME: Needed once authentication installed
      # customer_id = cas_session.user_id
      customer_id = ""

      utm_source = /utm_source=([^&]*)/.match(request.query_string)
      utm_medium = /utm_medium=([^&]*)/.match(request.query_string)
      utm_keyword = /utm_keyword=([^&]*)/.match(request.query_string)
      request_url = request.url.split("/redirection")[0]

      pub_ref = [
        request_url,
        request.remote_ip,
        customer_id,
        utm_source.try(:[], 1 ),
        utm_medium.try(:[], 1),
        utm_keyword.try(:[], 1)
      ].compact.join("%7C")

      product_tracking_url =
        "http://prf.hn/click/camref:#{cam_ref}/pubref:#{pub_ref}/adref:#{ad_ref}/" \
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

  def page_title(centre)
    if params[:sub_category].present? || params[:category].present?
      filter_param = params[:sub_category] || [params[:category]]
      "Buy #{filter_param.map{|param| param.titleize}.join(' and ')} online at #{centre.name}"
    else
      "Shopping at #{centre.name}"
    end
  end

  def description(centre)
    if params[:sub_category].present? || params[:category].present?
      filter_param = params[:sub_category] || [params[ :category]]
      "Browse the latest #{filter_param.map{|param| param.titleize}.join(' and ')} online at #{centre.name}"
    else
      "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at #{centre.name}"
    end
  end
end
