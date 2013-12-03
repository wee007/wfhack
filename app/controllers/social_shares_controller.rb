class SocialSharesController < ApplicationController

  def show
    @social_shareable = social_shareable.find params[:id]
    render layout: false
  end

  private

  def social_shareable
    "#{params[:kind]}_service".classify.constantize
  end

end