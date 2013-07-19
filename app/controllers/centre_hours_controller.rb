class CentreHoursController < ApplicationController

  layout 'hero', only: :show

  def show
    centre, trading_hours = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      trading_hours = CentreTradingHourService.fetch params[:centre_id]
    end
    @centre = CentreService.build centre
    @hours = CentreTradingHourService.build trading_hours
    @page_title = "#{@centre.name} hours"

    # TODO: Should this be a presenter?
    @hero = Hashie::Mash.new heading: 'heading',
                             text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Voluptatem distinctio quam ex aliquid incidunt repudiandae quisquam sequi ipsum? Porro possimus accusamus voluptas perspiciatis magnam minima nisi numquam architecto quod fugit.',
                             image: 'hours'
  end

end