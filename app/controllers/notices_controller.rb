class NoticesController < ApplicationController

  layout 'detail_view', only: :show

  def index
    @centre, @notices = in_parallel \
      centre: params[:centre_id],
      centre_service_notices: {centre: params[:centre_id], active: true}

    meta.push(
      page_title: "Notices and Activities at #{@centre.name}",
      description: "Find the latest notices and activities for children and adults taking place at #{@centre.name}"
    )
  end

  def show
    @centre, @notice = in_parallel \
      centre: params[:centre_id],
      centre_service_notice: params[:id]

    meta.push @notice.meta
    meta.push(
      page_title: "#{@notice.name} at #{@centre.name}",
      description: "At #{@centre.name}, #{@notice.description}"
    )
  end

end
