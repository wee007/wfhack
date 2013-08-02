class CentreHoursController < ApplicationController

  layout 'hero', only: :show

  def show
    centre, trading_hours = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      trading_hours = CentreTradingHourService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @weeks = CentreTradingHourService.weeks trading_hours
    @page_title = "#{@centre.name} hours"

    # TODO: Should this be a presenter?
    @hero = Hashie::Mash.new heading: 'Opening Hours',
                             image: 'hours'
  end

end