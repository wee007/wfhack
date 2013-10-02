class CentreHoursController < ApplicationController

  layout 'sub_page', only: :show

  def show
    centre, trading_hours = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      trading_hours = CentreTradingHourService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @weeks = CentreTradingHourService.build trading_hours

    # TODO: Should this be a presenter?
    @hero = Hashie::Mash.new heading: 'Opening Hours', image: 'opening-hours', icon: 'icon--hours'
    meta.push(
      page_title: "Opening Hours at #{@centre.name}",
      description: "Find #{@centre.name}'s opening and trading hours for today, this week and special shopping days"
    )
  end

end