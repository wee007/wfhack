class PrivacyPolicyController < ApplicationController

  layout 'detail_view', only: :index

  def index
    centres = CentreService.fetch( :all, country: 'au' )

    @centres = CentreService.build centres
    @centres = @centres.group_by{ |c| c.state } if @centres.present?

    meta.push(
      page_title: "Westfield Australia | Shopping Centres in NSW, QLD, VIC, SA & WA",
      description: "Find the best in retail, dining, leisure and entertainment at one of our centres across Australia, shop online or buy a gift card today",
      hide_social_share: true
    )
  end

end