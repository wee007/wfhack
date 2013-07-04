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
    centre, product = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      product = ProductService.fetch params.dup
    end
    @centre = CentreService.build centre
    @product = ProductService.build product
  end

end
