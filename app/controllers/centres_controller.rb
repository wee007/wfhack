class CentresController < ApplicationController

  def index
    @centres = CentreService.find :all, country: 'au'
    Rails.logger.info @centres
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

  def trading_hours_index
    @centres = CentreService.build CentreService.fetch params[ :centre_id ]
    render 'trading_hours/index'
  end

end
