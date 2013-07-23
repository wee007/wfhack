class StoresController < ApplicationController

  def index
    centre, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      store = StoreService.fetch centre: params[:centre_id], per_page: 1000
    end
    @centre = CentreService.build centre
    stores = StoreService.build(store).map {|store_attrs| Store.new(store_attrs) }
    gon.push(:centre => @centre, :stores => stores)
    @stores = stores.group_by(&:first_letter)
    @page_title = "#{@centre.short_name} stores"
  end

  def show
    centre, store = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      store = StoreService.fetch params[:id]
    end
    @centre = CentreService.build centre
    @store = Store.new StoreService.build store
    @page_title = "#{@store.name} at #{@centre.short_name}"
  end

end
