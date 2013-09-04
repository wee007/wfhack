class ProductsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, nearby_centres, products = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      nearby_centres = CentreService.fetch nil, near_to: params[:centre_id]
      products = ProductService.fetch params.merge({rows: 15})
    end
    @centre = CentreService.build centre
    @nearby_centres = CentreService.build nearby_centres
    @search = ProductService.build products

    meta.push title: "#{@centre.short_name} Products"

    if @search.is_a? NullObject
      handle_error(@search)
    else
      respond_to do |format|
        if request.xhr?
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
  end

  def show
    centre, product, stores = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      product = ProductService.fetch params.dup
      stores = StoreService.fetch retailer_code: params[:retailer_code], per_page: 1000
    end
    @centre = CentreService.build centre
    @product = ProductService.build product
    handle_error(@product) if @product.is_a? NullObject
    @stores = StoreService.build(stores)
    centre_ids = @stores.map(&:centre_id).uniq
    @centres = centre_ids.present? ? CentreService.find(:all, centre_id: centre_ids, near_to: params[:centre_id]) : []
    @centre_stores = @stores.select {|store| store['centre_id'] == @centre['code']}
    gon.push centre: @centre, stores: @centre_stores
    meta.push @product.meta
  end

end
