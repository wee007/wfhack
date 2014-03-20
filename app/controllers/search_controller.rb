class SearchController < ApplicationController
  def index
    @centre, @search = service_map \
      centre: params[:centre_id],
      search: {centre: params[:centre_id], term: params[:search_query]}
    meta.push page_title: "Westfield Australia | Search"
    gon.search_query = params[:search_query]

    @icon_names = {stores: 'store', products: 'products'}
  end
end