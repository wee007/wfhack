class CurationsController < ApplicationController

  def show
    if params[:centre_id]
      @curation, @centre = service_map service_params
    else
      @curation, centres = service_map service_params
      @centres_by_state = centres_by_state centres
    end

    if @curation.present?
      meta.push @curation.meta
      meta.push seo_meta_params
    else
      raise URI::InvalidURIError
    end
  end

  private

  def service_params
    curation_param.merge centre_param
  end

  def curation_param
    { curation: { code: params[:slug], centre: params[:centre_id] }}
  end

  def centre_param
    { centre: (params[:centre_id] || [ :all, country: 'au' ]) }
  end

  def seo_meta_params
    location = @centre.present? ? @centre.name : 'Westfield'
    page_title = [ @curation.name, location ].join(' at ')
    { page_title: page_title, description: @curation.description }
  end

  def centres_by_state centres
    if centres
      centres.group_by { |centre| centre.state }
    else
      Hash nil
    end
  end

end
