class CentresController < ApplicationController
  layout 'national', :only => :index

  def index
    centres, products = nil
    Service::API.in_parallel do
      centres = CentreService.fetch( :all, country: 'au' )
      products = ProductService.fetch( rows: 1 )
    end

    @centres = CentreService.build centres
    @centres = @centres.group_by{ |c| c.state } if @centres.present?

    @products = ProductService.build products
    @products_count = @products['count'].round(-2) if @products.present?
  end

  def show
    stream
    handle_error(@centre) if @centre.is_a?(NullCentre)
    meta.push title: @centre.short_name
  end

  def product_stream
    stream 'product'
    if @centre.is_a?(NullCentre)
      handle_error(@centre)
    else
      render :show
    end
  end

private
  def stream(filter=nil)
    centre, stream = nil
    stream_params = {centre: params[:id]}
    stream_params.merge!(stream: filter) if filter
    Service::API.in_parallel do
      centre = CentreService.fetch(params[:id])
      stream = StreamService.fetch(stream_params)
    end
    @centre = CentreService.build centre
    @stream = StreamService.build stream
  end

end
