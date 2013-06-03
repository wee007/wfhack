class CentresController < ApplicationController
  def show
    centre, stream = nil
    Service::API.in_parallel do
      centre = CentreService.fetch(params[:id])
      stream = StreamService.fetch(params[:id])
    end
    @centre = centre.body
    @stream = stream.body['stream']
  end
end
