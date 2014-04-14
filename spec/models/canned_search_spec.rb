require 'spec_helper'

describe CannedSearch do

  let :canned_search_data do
    {
      "id" => 1,
      "name" => "A canned search",
      "centre_id" => "bondijunction",
      "url" => "/a/dummy/url/and/an/edit",
      "image_ref" => "image_ref",
      "image_alt" => "An alt tag",
      "start_date" => "2013-09-29",
      "end_date" => "2013-09-30",
      "type" => "canned_search",
      "_links" => {
        "self" => {"href" => "/a/dummy/url/and/an/edit"},
        "centre" => {"href" => "http://centre-service.development.dbg.westfield.com/api/centre/master/centres/bondijunction.json"},
        "image" => {"href" => "http://res.cloudinary.com/wlabs/image/upload/image_ref.jpg"}
      }
    }
  end

  let(:canned_search) { CannedSearch.new canned_search_data }

  it "should have a name" do
    canned_search.name.should eq "A canned search"
  end

  it "should have an image" do
    canned_search.image.should include("image_ref")
  end

  it "should have an alt tag" do
    canned_search.image_alt.should == "An alt tag"
  end

  it "should have a start date" do
    canned_search.start_date.should eql("2013-09-29")
  end

  it "should be able to have it's start date formatted" do
    canned_search.start_date("%c").should eql("Sun Sep 29 00:00:00 2013")
  end

  it "should have an end date" do
    canned_search.end_date.should eql("2013-09-30")
  end

  it "should be able to have it's end date set" do
    canned_search.end_date("%c").should eql("Mon Sep 30 00:00:00 2013")
  end

  it "should return canned_search as it's kind" do
    canned_search.kind.should == "canned_search"
  end

  it "should recognize the routes for the various types of tiles" do
    tile_routes = [
      "/bondijunction/products",
      "/bondijunction/stores/1001-optical/21256",
      "/bondijunction/hours",
      "/bondijunction/info",
      "/bondijunction/deals"
    ]
    tile_routes.each do |r|
      lambda {
        Rails.application.routes.recognize_path(r)
      }.should_not raise_exception
    end
  end

  it "should be able to recognize the various routes to apply the correct icon" do
    routes_and_icons = {
      "/bondijunction/products" => "product",
      "/bondijunction/stores/1001-optical/21256" => "store",
      "/bondijunction/hours" => "hours",
      "/bondijunction/info" => "info",
      "/bondijunction/deals" => "deal"
    }

    routes_and_icons.each do |url,icon|
      canned_search.url = url
      canned_search.icon.should == icon
    end
  end

  it "should be able to recognize the routes to generate a tag line" do
    routes_and_tag_lines = {
      "/bondijunction/products" => "View collection",
      "/bondijunction/stores/1001-optical/21256" => "View store details",
      "/bondijunction/hours" => "View shopping hours",
      "/bondijunction/info" => "View details",
      "/bondijunction/notices" => "View details",
      "/bondijunction/service" => "View details",
      "/bondijunction/random_url" => "View details",
      "/bondijunction/deals" => "View deals"
    }

    routes_and_tag_lines.each do |url,tag_line|
      canned_search.url = url
      canned_search.tag_line.should == tag_line
    end
  end

  it "should have a default icon" do
    canned_search.url = "/anything"
    canned_search.icon.should == "search"
  end

end
