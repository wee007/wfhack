class StoresController < ApplicationController

  def index
    push_store_info_to_gon
    @stores = stores.group_by(&:first_letter)
    meta.push(
      page_title: "Stores at #{centre.name}",
      description: "Find your favourite store at #{centre.name} along with a map to help you easily find its location"
    )
  end

  def show
    push_store_info_to_gon
    meta.push(
      page_title: "#{store.name} at #{centre.name}",
      description: store.description.try(:truncate, 156)
    )
  end

protected

  def store
    @store ||= stores.find {|store| store.id.to_s == params[:id] }
  end

  def centre
    fetch_centre_and_stores unless @centre.present?
    @centre
  end

  def stores
    fetch_centre_and_stores unless @stores.present?
    @stores
  end

  def fetch_centre_and_stores
    centre, stores, products = nil
    Service::API.in_parallel do
      centre = CentreService.fetch params[:centre_id]
      stores = StoreService.fetch centre: params[:centre_id], per_page: 1000
      products = ProductService.fetch action: 'lite', retailer: [params[:retailer_code]], rows: 3
    end
    @centre = CentreService.build centre
    @stores = StoreService.build(stores, centre: @centre)
    @products = ProductService.build(products)
  end

  def push_store_info_to_gon
    gon.push centre: centre, stores: stores.map(&:to_gon)
  end

end
