class StyleguideController < ApplicationController
  layout "styleguide"
  helper_method :styleguide

  def index
    meta.push(
      page_title: "Westfield Style Guide",
      description: "Style Guide for AU Westfield website"
    )
  end

  def show
    meta.push(
      page_title: "Westfield Style Guide",
      description: "Style Guide for AU Westfield website"
    )
    render template: "styleguide/#{params[:id]}"
  end

  def static
    meta.push(
      page_title: "Westfield Style Guide",
      description: "Style Guide for AU Westfield website"
    )
    render template: "styleguide/static/#{params[:file]}", layout: false
  end

  private

  def styleguide
    @styleguide = Kss::Parser.new(Rails.root.join('app/assets/stylesheets'))
  end
end