class CurationsController < ApplicationController

  before_action :setup

  def show
    @centre = service_map(centre: params[:centre_id]).first
  end

protected

  def setup
    centres = CentreService.find :all, country: 'au'
    @centres = centres.group_by{ |c| c.state } if centres.present?
    meta.push(
      page_title: "",
      description: ""
    )
  end

end