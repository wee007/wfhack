require 'spec_helper'

describe Event do

  let :event_data do
    {
      start: '2013-07-01T19:59:37Z',
      finish: '2013-07-09T19:59:37Z',
      "_links" => {image: {href: 'image_link'}},
      body: "one
      two
      three"
    }
  end
  subject { Event.new event_data }

  context '#start' do
    it { subject.start.should eql("2013-07-01T19:59:37Z") }
    it { subject.start("%c").should eql("Mon Jul  1 19:59:37 2013") }
  end

  context '#finish' do
    it { subject.finish.should eql("2013-07-09T19:59:37Z") }
    it { subject.finish("%c").should eql("Tue Jul  9 19:59:37 2013") }
  end

  context '#body' do
    it { subject.body.should eql(%w{one two three}) }
  end

  context '#image' do
    it { subject.image.should =~ /#{event_data[:image_ref]}/ }
  end

end