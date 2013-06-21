class TradingHoursController < ApplicationController

  def index
    @centre = @centres = CentreService.build CentreService.fetch params[ :centre_id ]
  end

end