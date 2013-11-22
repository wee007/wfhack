require 'spec_helper'

describe RedirectorHelper do
  it "should return a category" do
    helper.extract_category_from_url("womens-fashion-accessories/bl-handbags/bl-handbags-clutch%20<br/>").should eql "bl-handbags-clutch"
  end
end