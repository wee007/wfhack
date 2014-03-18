require 'spec_helper'

describe 'curations/_tile_hero.html.erb' do
  let(:image_url) { 'abc.jpg' }
  let(:tile_hero) {{ id: 666, image_url: image_url }}
  before { view.stub(:tile_hero) { tile_hero }}
  subject { render; rendered }
  it { should match %r{#{image_url}} }
end