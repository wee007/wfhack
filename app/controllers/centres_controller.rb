class CentresController < ApplicationController
  def show
    centre, stream = nil
    Service::API.in_parallel do
      centre = Service::API.get CentreService.request_uri(params[:id])
      stream = Service::API.get StreamService.request_uri(params[:id])
    end
    @centre = CentreService.build centre
    @stream = StreamService.build stream
  end
end
