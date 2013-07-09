class ProductsController < ApplicationController

  layout 'detail_view', only: :show

  def index
    centre, products = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      products = ProductService.fetch params
    end
    @centre = CentreService.build centre
    @search = ProductService.build products
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
    @stores = StoreService.build(stores)
    centre_ids = @stores.map(&:centre_id).uniq
    @centres = centre_ids.present? ? CentreService.find(:all, centre_id: centre_ids) : []
    gon.push(:centre => @centre, :stores => @stores)
  end

end
