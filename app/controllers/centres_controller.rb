class CentresController < ApplicationController
  layout 'base', :only => :index

  before_action do
    gon.push(
      centre_id: params[:id]
    )
  end

  def index
    @centres, @products = service_map \
      centre: [:all, {country: 'au'}],
      product: {rows: 1}

    @centres_by_state = @centres.group_by{ |c| c.state } if @centres.present?
    if @products.present? && @products['count'].respond_to?(:round)
      @products_count = @products['count'].round(-2)
    end

    meta.push(
      page_title: "Westfield Australia | Shopping Centres in NSW, QLD, VIC, SA & WA",
      description: "Find the best in retail, dining, leisure and entertainment at one of our centres across Australia, shop online or buy a gift card today"
    )

    gon.push geo: @centres.collect { |centre| {
      name: centre.short_name,
      code: centre.code,
      latitude: centre.latitude,
      longitude: centre.longitude,
      state: centre.state
    }}
  end

  def show
    stream

    meta.push(
      page_title: @centre.name,
      description: @centre.description
    )
  end

private

  # TODO: move over to the new in_parallel stuff
  def stream(filter=nil)
    centre, stream = nil
    stream_params = {centre: params[:id]}
    stream_params.merge!(stream: filter) if filter

    Service::API.in_parallel do
      centre = CentreService.fetch(params[:id])
      stream = StreamService.fetch(stream_params)
    end

    @centre = CentreService.build centre
    @stream = StreamService.build(stream, timezone: @centre.timezone)

    centre_trading_hours = CentreTradingHourService.fetch(params[:id], {from: Time.now.in_time_zone(@centre.timezone).strftime("%Y-%m-%d"), to: Time.now.in_time_zone(@centre.timezone).strftime("%Y-%m-%d")})
    @centre_trading_hour = CentreTradingHourService.build(centre_trading_hours)
  end

end
