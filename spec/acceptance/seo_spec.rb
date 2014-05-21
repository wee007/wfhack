require 'acceptance_helper'

feature 'SEO' do
  include_context 'seo'
  
  if environment_greater_than_or_equal_to? 'uat'
    let(:target_pages) { get_target_pages }
    
    describe 'Title and Meta Description' do
      scenario 'are present and unique' do
        meta_tags, titles = get_meta_tags_and_titles_for(target_pages)
        
        expect(check_uniqueness('meta description', meta_tags)).to be_true
        expect(check_uniqueness('title', titles)).to be_true
      end
    end
    
    describe 'Canonical links' do
      scenario "there's only one and it matches the page url" do
        expect(check_canonical_links_for(target_pages)).to be_true
      end
    end
  
    describe 'Canonical links for Product search' do
      scenario "has only one per page" do
        visit "/sydney/products"
        expect_one('link[rel=canonical]', :visible => false)
      end
      
      scenario "search results matches the page url" do
        sample_urls = [
          centre_products_path('sydney'),
          centre_products_super_cat_path('sydney', 'womens-fashion-accessories'),
          centre_products_category_path('sydney', 'womens-fashion-accessories', 'womens-shoes-footwear', :sub_category => 'womens-heels', :rows => 50, :colour => 'Yellows', :on_sale => 'true', :price => '100-200')
        ]
        sample_urls.each do |url|
          visit url
          expect_canonical_link_to_match_url
        end
      end
    end
  end
end