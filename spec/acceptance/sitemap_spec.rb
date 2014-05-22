require 'acceptance_helper'

feature 'Sitemaps and robots.txt' do
  
  describe 'Robots.txt' do
    if environment_greater_than_or_equal_to? 'production' 
      scenario 'Production should provide a link to the sitemap' do
        visit '/robots.txt'
        expect(page).to have_content 'Sitemap: http://www.westfield.com.au/sitemap.xml.gz'
      end
    else
      scenario 'Test environments should disallow robots' do
        visit '/robots.txt'
        expect(page.body).to match /^Disallow: \//
      end
    end
  end

  if environment_greater_than_or_equal_to? 'production' 
    describe 'Sitemaps' do
      scenario 'The sitemap should have been updated within the last 24 hours and contain multiple sub-sitemaps' do
        visit '/sitemap.xml.gz'
        gz = Zlib::GzipReader.new(StringIO.new(page.body))
        inflated = gz.read
        # currently (May 2014) we should have 4 split sitemaps
        expect(inflated).to have_xpath '//sitemap', :minimum => 4
        # each of our sub-sitemaps should have been created within the last day
        inflated.scan(/<lastmod>(.*?)<\/lastmod>/).each do |d|
          date = Date.parse(d[0])
          expect(date).to be_within(1).of(Date.today)
        end
      end
    end
  end
end
