class CurationsController < ApplicationController

  def show
    @centre, @curation = service_map \
      centre: params[:centre_id],
      curation: { code: params[:slug], centre: params[:centre_id] }
    if @curation == []
      # If we don't find a curation, this is a dead link
      # We can't raise a 404 from inside curations because it exposes a search API 
      # - no results is only an error for this specific action
      raise URI::InvalidURIError
    end
    meta.push @curation.meta
    meta.push \
      page_title: "#{@curation.name} at #{@centre.name}",
      description: @curation.description
  end

end
