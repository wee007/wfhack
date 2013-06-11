class TradingHoursController < ApplicationController

  def index
    @centres = CentreService.build CentreService.fetch params[ :centre_id ]
  end

end