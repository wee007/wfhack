class StoresController < ApplicationController

  def index
    centre, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      store = StoreService.fetch centre: params[:centre_id], rows: 50
    end
    @centre = CentreService.build centre
    @stores = StoreService.build store
    gon.push(:centre => @centre)
  end

end
