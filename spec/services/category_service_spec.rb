require 'spec_helper'
describe CategoryService do

  context "Build" do
    describe "When we've only asked for one category" do
      it "return category objects" do
        mock_response = double(:body => [{"title" => "Category 1"},{"title" => "Category 2"}])
        categories = CategoryService.build(mock_response)
        expect(categories.size).to eql(2)
        expect(categories[0].title).to eql("Category 1")
        expect(categories[1].title).to eql("Category 2")
      end
    end
  end

  context "Mappings" do
    describe "Should parse the categories into a hash of old_category => new_category mappings" do
      it "parses the categories" do
        mock_response = [
                         Hashie::Mash.new(code: "womens-fashion-accessories",
                           children: [Hashie::Mash.new(code: "womens-shoes-footwear",
                             children: [Hashie::Mash.new(code: "womens-heels")])]),
                         Hashie::Mash.new(code: "mens-fashion-accessories",
                           children: [Hashie::Mash.new(code: "mens-clothing",
                             children: [Hashie::Mash.new(code: "mens-coats-jackets"), 
                                        Hashie::Mash.new(code: "mens-exercise-active-wear"), 
                                        Hashie::Mash.new(code: "mens-jeans")])])]


        CategoryService.stub(:find).and_return(mock_response)

        categories = CategoryService.category_mappings
        
        expect(categories["womens-fashion-accessories"]).to   eql("super_cat")
        expect(categories["womens-shoes-footwear"]).to        eql("category")
        expect(categories["womens-heels"]).to                 eql("sub_category")
        expect(categories["mens-fashion-accessories"]).to     eql("super_cat")
        expect(categories["mens-clothing"]).to                eql("category")
        expect(categories["mens-coats-jackets"]).to           eql("sub_category")
        expect(categories["mens-exercise-active-wear"]).to    eql("sub_category")
        expect(categories["mens-jeans"]).to                   eql("sub_category")
      end
    end
  end
end
