require 'spec_helper'

describe ApplicationHelper do

  context "#responsive_image_tag" do

    let(:placeholder) { 'placeholder_image.png' }
    let(:normal) { 'normal_image.png' }
    let(:retina) { 'retina_image.png' }
    
    it "returns an image tag" do
      responsive_image_tag(placeholder: placeholder, normal: normal).should == image_tag(placeholder, data: {src: normal}) + content_tag(:noscript) { image_tag normal }
    end

    it "includes the retina image" do
      responsive_image_tag(placeholder: placeholder, normal: normal, retina: retina).should == image_tag(placeholder, data: {src: normal, :'src-retina' => retina}) + content_tag(:noscript) { image_tag normal }
    end

  end

end
