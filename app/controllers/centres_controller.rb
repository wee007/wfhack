class CentresController < ApplicationController

  def index
    @centres = CentreService.find :all, country: 'au'
    @centres = @centres.group_by {|c| c.state }
    @centres
  end

  def show
    centre, stream = nil
    Service::API.in_parallel do
      centre = CentreService.fetch(params[:id])
      stream = StreamService.fetch(params[:id])
    end
    @centre = CentreService.build centre
    @stream = StreamService.build stream
  end

end
