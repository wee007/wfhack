class Movie < Hashie::Mash
  def meta
    Meta.new title: "#{title} at Westfield",
             twitter_title: "Do you want to see this movie, #{title}?"
  end
end