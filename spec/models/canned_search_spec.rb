require 'spec_helper'

describe CannedSearch do

  let :canned_search_data do
    {
      "id" => 1,
      "centre_id" => "bondijunction",
      "name" => "A canned search",
      "url" => "/a/dummy/url/and/an/edit",
      "image_ref" => "image_ref",
      "image_uri" => "http://res.cloudinary.com/wlabs/image/upload/image_ref.jpg",
      "start_date" => "2013-09-29",
      "end_date" => "2013-09-30",
      "updated_at" => "2013-09-29T21 => 59 => 55Z"
    }
  end

  subject { CannedSearch.new canned_search_data }

  context '#name' do
    it { subject.name.should eq "A canned search" }
  end

  context '#image' do
    it { subject.image.should include("image_ref") }
  end

  context '#start_date' do
    it { subject.start_date.should eql("2013-09-29") }
    it { subject.start_date("%c").should eql("Sun Sep 29 00:00:00 2013") }
  end

  context '#end_date' do
    it { subject.end_date.should eql("2013-09-30") }
    it { subject.end_date("%c").should eql("Mon Sep 30 00:00:00 2013") }
  end

end