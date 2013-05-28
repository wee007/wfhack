require 'roar/representer/feature/client'
require "movierepresenters/movie_representer.rb"

class Movie
  include Roar::Representer::Feature::HttpVerbs

  attr_accessor :title

  def initialize(*)
    extend Movierepresenters::MovieRepresenter
    extend Roar::Representer::Feature::Client
  end

end