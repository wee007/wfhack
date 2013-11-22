module RedirectorHelper
  def extract_category_from_url(path)
    # safely parse the URL
    # URI will not parse a 'path' alone, so we use a dummy tld
    # and pull the path after the url has been cleaned and parsed
    clean_uri = URI.extract("http://dummy.tld/" + path).first
    path = URI.parse(clean_uri).path

    # take the last path component
    path.split('/').last.try(:match, /[a-zA-z\-]+/).to_s
  end
end