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
        pending
      end
    end
  end
end
