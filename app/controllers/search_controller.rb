class SearchController < ApplicationController
  def index
    @centre, search = service_map \
      centre: params[:centre_id],
      search: {centre: params[:centre_id], term: params[:search_query]}
    meta.push page_title: "Westfield Australia | Search"

    gon.push \
      search_query: params[:search_query],
      centre: params[:centre_id],
      google_content_experiment: params[:gce_var]

    if (search.hard_redirect?)
      redirect_to search.first_result_uri_path
    end

    @sorted_results_tuple = search.sort
    @search_term = search.term

    if @sorted_results_tuple.empty?
      @links = []
      @links.push Hashie::Mash.new url: centre_stores_path(@centre.code), label: "Stores", icon: "store"
      @links.push Hashie::Mash.new url: centre_products_path(@centre.code), label: "Products", icon: "product"
      @links.push Hashie::Mash.new url: centre_deals_path(@centre.code), label: "Deals", icon: "deal"
      @links.push Hashie::Mash.new url: centre_events_path(@centre.code), label: "Events", icon: "event"
      @links.push Hashie::Mash.new url: centre_hours_path(@centre.code), label: "Shopping Hours", icon: "hours"
      @links.push Hashie::Mash.new url: centre_movies_path(@centre.code), label: "Cinemas", icon: "video" if @centre.cinema
      @links.push Hashie::Mash.new url: centre_info_path(@centre.code), label: "Centre Information", icon: "info"
      @links.push Hashie::Mash.new url: centre_services_path(@centre.code), label: "Centre Services", icon: "service"
    end

  end

end