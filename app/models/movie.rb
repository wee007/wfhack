class Movie

  def self.get
    conn = Faraday.new(:url => 'http://localhost:3001') do |faraday|
      faraday.adapter  Faraday.default_adapter
    end

    response = conn.get("/api/movie/master/movies.json?centre=bondijunction")
    JSON.parse(response.body)['movies'].map{|movie| OpenStruct.new(movie) }
  end
  
end