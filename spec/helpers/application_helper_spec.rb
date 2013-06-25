require 'spec_helper'

describe ApplicationHelper do

  context "#responsive_image_tag" do

    let(:default_placeholder) { 'http://image-service.test.dbg.westfield.com/transform?url=http://customer-console.test.dbg.westfield.com/assets/logo-tile.png&size=60x60&pad=true&background=ffffff' }
    let(:placeholder) { 'placeholder_image.png' }
    let(:normal) { 'normal_image.png' }
    let(:retina) { 'retina_image.png' }

    it "returns the image with default placeholder" do
      responsive_image_tag(normal: normal).should == image_tag(default_placeholder, :'data-src' => normal) + content_tag(:noscript) { image_tag normal }
    end
    
    it "returns an image tag" do
      responsive_image_tag(placeholder: placeholder, normal: normal).should == image_tag(placeholder, data: {src: normal}) + content_tag(:noscript) { image_tag normal }
    end

    it "includes the retina image" do
      responsive_image_tag(placeholder: placeholder, normal: normal, retina: retina).should == image_tag(placeholder, data: {src: normal, :'src-retina' => retina}) + content_tag(:noscript) { image_tag normal }
    end

  end

end
