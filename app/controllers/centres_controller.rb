class CentresController < ApplicationController
  layout 'national', :only => :index


  def index
    @centres = CentreService.find :all, country: 'au'
    @centres = @centres.group_by {|c| c.state }
    @centres
  end

  def show
    stream
  end

  def product_stream
    stream 'product'
    render :show
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
