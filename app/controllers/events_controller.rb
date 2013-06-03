class EventsController < ApplicationController

  def show
    @event = Service::API.get "#{url}/#{params[:id]}"
  end

  def index
    @events = Service::API.get url, rows: 50, centre: params[:centre_id]
  end

private

  def url
    "#{ENV['HOST']}/api/event/master/events"
  end

end