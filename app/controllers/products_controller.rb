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
    centre, product, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      product = ProductService.fetch params.dup
      store = StoreService.fetch centre: params[:centre_id], per_page: 1000
    end
    @centre = CentreService.build centre
    @product = ProductService.build product
    stores = StoreService.build(store).map {|store_attrs| Store.new(store_attrs) }
    gon.push(:centre => @centre, :stores => stores)
  end

end
