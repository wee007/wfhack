require 'roar/representer/feature/client'
require "movierepresenters/movie_representer.rb"
require "movierepresenters/movies_representer.rb"

class Movies
  include Roar::Representer::Feature::HttpVerbs

  def initialize
    extend Movierepresenters::MoviesRepresenter
    extend Roar::Representer::Feature::Client
  end
end