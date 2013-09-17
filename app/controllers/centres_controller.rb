class CentresController < ApplicationController
  layout 'national', :only => :index

  def index
    @stores = StoreService.find
    @stores_count = ( @stores.count*100 ).ceil/100 if @stores.present?

    @products = ProductService.find( {} )
    @products_count = ( @products['count']*100 ).ceil/100 if @products.present?

    @centres = CentreService.find( :all, country: 'au' )
    @centres = @centres.group_by{ |c| c.state } if @centres.present?
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
