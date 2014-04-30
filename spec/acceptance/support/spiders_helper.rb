shared_context "spiders" do
  def major_console_pages
    visit '/bondijunction/movies'
    movie = all(:css, 'article.test-movie a').first
    log "test movie: #{movie['href']}" if movie
    movie_page = movie ? movie['href'] : ''
    movie_content = movie ? 'Session Times' : ''
    [
      { :name => 'National', :content => 'Find your centre', :url => '/' },
      { :name => 'Centre Home Page', :content => 'Centre Information', :url => '/bondijunction' },
      { :name => 'Centre Information', :content => 'Getting Here', :url => '/bondijunction/info' },
      { :name => 'Centre Services', :content => 'Centre services', :url => '/bondijunction/services' },
      { :name => 'Centre Hours', :content => 'Shopping Hours', :url => '/bondijunction/hours' },
      { :name => 'Cinema Home', :content => 'Event Cinemas', :url => '/bondijunction/movies' },
      { :name => 'Cinema Session', :content => movie_content, :url => movie_page },
      { :name => 'Stores', :content => 'Category filter', :url => '/bondijunction/stores' },
      { :name => 'Products', :content => 'Products', :url => '/bondijunction/products' },
      { :name => 'Deals', :content => 'Deals', :url => '/bondijunction/deals' },
      { :name => 'Events', :content => 'Events', :url => '/bondijunction/events' }
    ]
  end
end