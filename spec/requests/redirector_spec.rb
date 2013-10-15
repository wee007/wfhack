require 'spec_helper'

describe RedirectorController do

  context "GET" do

    it 'follows redirects' do
      [
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-dresses",
        "http://www.example.com/products?category=womens-dresses"],
       [
        "/au/shopping/womens-fashion-accessories/womens-maternity/w-dresses-maternity",
        "http://www.example.com/products"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-dresses?retailer=forcast",
        "http://www.example.com/products?category=womens-dresses&retailer=forcast"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing",
        "http://www.example.com/products"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-swimwear?type=w-swim-bikini",
        "http://www.example.com/products?sub_category=w-swim-bikini"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-swimwear",
        "http://www.example.com/products?category=womens-swimwear"],
       [
        "/au/shopping/womens-fashion-accessories/bl-handbags",
        "http://www.example.com/products?category=bl-handbags"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-jeans?type=w-jeans-skinny",
        "http://www.example.com/products?category=womens-pants"],
       [
        "/au/shopping/mens-fashion-accessories/mens-watches",
        "http://www.example.com/products"],
       [
        "/au/shopping/shoes-footwear",
        "http://www.example.com/products?super_cat=shoes-footwear"],
       [
        "/au/shopping/shoes-footwear/womens-shoes-footwear",
        "http://www.example.com/products?category=womens-shoes-footwear"],
       [
        "/au/shopping/shoes-footwear/womens-plus-swimwear?retailer=oroton",
        "http://www.example.com/products?category=womens-plus-size&retailer=oroton"],
       [
        "/au/shopping/shoes-footwear/mens-shoes-footwear",
        "http://www.example.com/products?category=mens-shoes-footwear"],
       [
        "/au/shopping/mens-fashion-accessories/mens-clothing/mens-shirts",
        "http://www.example.com/products?category=mens-shirts"],
       [
        "/au/shopping/mens-fashion-accessories/mens-clothing/mens-shirts?retailer=lowes",
        "http://www.example.com/products?category=mens-shirts&retailer=lowes"],
       [
        "/au/shopping/mens-fashion-accessories/mens-clothing/mens-underwear-socks",
        "http://www.example.com/products?category=mens-underwear-socks"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-skirts",
        "http://www.example.com/products?category=womens-skirts"],
       [
        "/au/shopping/womens-fashion-accessories",
        "http://www.example.com/products?super_cat=womens-fashion-accessories"],
       [
        "/au/shopping/mens-fashion-accessories/mens-accessories/mens-ties",
        "http://www.example.com/products?sub_category=mens-ties"],
       [
        "/au/shopping/mens-fashion-accessories/mens-accessories/mens-ties?type=m-ties-bowties",
        "http://www.example.com/products?category=mens-accessories"],

       [
        "au/shopping/mens-fashion-accessories/mens-accessories/mens-ties?type=m-ties-business-ties",
        "http://www.example.com/products?category=mens-accessories"],
       [
        "/au/shopping/womens-fashion-accessories/womens-accessories",
        "http://www.example.com/products?category=womens-accessories"],
       [
        "/au/shopping/womens-fashion-accessories/womens-accessories/womens-belts",
        "http://www.example.com/products?sub_category=womens-belts"],
       [
        "/au/shopping/mens-fashion-accessories/mens-clothing/mens-coats-jackets",
        "http://www.example.com/products?category=mens-coats-jackets"],
       [
        "/au/shopping/mens-fashion-accessories/mens-clothing/mens-coats-jackets?type=m-coats-leather",
        "http://www.example.com/products?sub_category=m-coats-leather"],
       [
        "/au/shopping/womens-fashion-accessories/womens-clothing/womens-coats-jackets",
        "http://www.example.com/products?category=womens-coats-jackets"],
       [
        "/au/shopping/womens-fashion-accessories/bl-handbags/bl-handbags-clutch",
        "http://www.example.com/products?sub_category=bl-handbags-clutch"],
      ].each do |source_url,redirected_to|
        get source_url
        response.should redirect_to(redirected_to)
      end
    end
  end
end
