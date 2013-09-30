class ProductsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, centres, nearby_centres, products = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id] if params[:centre_id]
      nearby_centres = CentreService.fetch nil, near_to: params[:centre_id] if params[:centre_id]
      centres = CentreService.fetch :all, country: 'au' unless params[:centre_id]
      products = ProductService.fetch params.merge({rows: 50})
    end

    if params[:centre_id]
      @centre = CentreService.build centre
      @nearby_centres = CentreService.build nearby_centres

      meta.push(
        page_title: "Shopping at #{@centre.name}",
        description: "Find the latest fashion, clothes, shoes, jewellery, accessories and much more at #{@centre.name}"
      )
    else
      @centres = CentreService.group_by_state centres
    end
    @search = ProductService.build products

    handle_error(@search) if @search.is_a? NullObject
    respond_to do |format|
      if request.xhr?
        # This should be its own route? There is alot of stuff above it does not need.
        format.html { render partial: "products" }
      else
        gon.products = {
          page: (params[:page] || 1),
          count: @search['count'],
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
    handle_error(@product) if @product.is_a? NullObject

    if params[:centre_id]
      stores = StoreService.build(stores)
      centre_ids = stores.map(&:centre_id).uniq
      @centre_stores = stores.select {|store| store['centre_id'] == params[:centre_id]}
      @product_centres = centre_ids.present? ? CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id]) : []
      @centre = CentreService.build centre
      gon.push centre: @centre, stores: @centre_stores
      meta.push(
        page_title: "#{@product.name} | #{@centre.name}",
        description: "Shop for #{@product.name} from #{stores.first.try(:name)} at #{@centre.name}"
      )
    else
      @centres = CentreService.group_by_state centres
    end

    meta.push @product.meta
  end

end
