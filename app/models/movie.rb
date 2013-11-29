class Movie < Hashie::Mash
  def meta
    Meta.new title: "#{title} Movie",
             twitter_title: "Do you want to see this movie, #{title}?",
             email_body: "movie",
             kind: kind,
             id: id
  end

  def kind
    self.class.name.downcase
  end

end