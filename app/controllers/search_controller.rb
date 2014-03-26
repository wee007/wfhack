class SearchController < ApplicationController
  def index
    @centre, @search = service_map \
      centre: params[:centre_id],
      search: {centre: params[:centre_id], term: params[:search_query]}
    meta.push page_title: "Westfield Australia | Search"

    gon.search_query = params[:search_query]

    gon.centre = params[:centre_id]

    # See WSF-6243; if we have only one hardcoded result, go straight to the result.
    if (@search.results.count == 1)
      # I'm sure there's a nicer way to access the result info; I'd love to hear about it in the code review :)
      sole_result = @search.results.first
      if sole_result.first == "centre_information"
        redirect_to sole_result.second.first["attributes"]["path"]
      end
    end

    # TODO: sort by search model
    @search.results = @search.results.sort.reverse

  end
end