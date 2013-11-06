class Movie < Hashie::Mash

  def url_safe_title
    URI.escape(title)
  end

end