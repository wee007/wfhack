class Movie < Hashie::Mash
  def meta
    Meta.new title: "#{title} Movie",
             twitter_title: "Do you want to see this movie, #{title}?",
             email_body: "movie"
  end
end