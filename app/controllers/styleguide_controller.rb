class StyleguideController < ApplicationController
  layout "styleguide"
  helper_method :styleguide

  def index
    meta.push(
      page_title:"Style guide",
      description: ""
    )
  end

  def show
    meta.push(
      page_title:"",
      description: ""
    )
    render template: "styleguide/#{params[:id]}"
  end

  private

  def styleguide
    @styleguide = Kss::Parser.new(Rails.root.join('app/assets/stylesheets'))
  end
end