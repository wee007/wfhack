class SearchController < ApplicationController
  def index
    @centre, search = service_map \
      centre: params[:centre_id],
      search: {centre: params[:centre_id], term: params[:search_query]}
    meta.push page_title: "Westfield Australia | Search"

    gon.search_query = params[:search_query]

    gon.centre = params[:centre_id]

    @links = {
      "stores" => 'store',
      "products" => 'product'
    }
    @attributes = Hashie::Mash.new action: 'index'

    if (search.hard_redirect?)
      redirect_to search.first_result_uri_path
    end

    @sorted_results_tuple = search.sort
    @search_term = search.term

  end

end