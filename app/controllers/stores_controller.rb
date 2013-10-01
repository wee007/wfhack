class StoresController < ApplicationController

  def index
    centre, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      store = StoreService.fetch centre: params[:centre_id], per_page: 1000
    end
    @centre = CentreService.build centre
    stores = StoreService.build(store, centre: @centre)
    @stores = stores.group_by(&:first_letter)
    gon.push centre: @centre, stores: stores.map(&:to_gon)
    meta.push title: "#{@centre.short_name} stores"
  end

  def show
    centre, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      store = StoreService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @store = StoreService.build(store, centre: @centre)
    gon.push centre: @centre, stores: [@store.to_gon]
    meta.push title: "#{@store.name} at #{@centre.short_name}"
  end

end
