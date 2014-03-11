require 'spec_helper'

describe RobotsController do

  let(:double_io) { double(:io, read: 'data', meta: {}) }

  before :each do
    Time.stub(:now).and_return 1
  end

  describe "GET #sitemap" do
    it 'with no :id' do
      controller.should_receive(:open).with('http://res.cloudinary.com/wlabs/raw/upload/v1/test_sitemap.xml.gz', proxy: AppConfig.proxy).and_return double_io
      get :sitemap
    end

    it 'with an :id' do
      controller.should_receive(:open).with('http://res.cloudinary.com/wlabs/raw/upload/v1/test_sitemap1.xml.gz', proxy: AppConfig.proxy).and_return double_io
      get :sitemap, id: 1
    end
  end

end