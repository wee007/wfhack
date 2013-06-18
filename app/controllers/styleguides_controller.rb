class StyleguidesController < ApplicationController
  layout "styleguide"
  helper_method :styleguide

  def show
    render template: "styleguides/#{params[:id]}"
  end

  private

  def styleguide
    @styleguide = Kss::Parser.new(Rails.root.join('app/assets/stylesheets'))
  end
end