require 'spec_helper'

describe Event do

  let :event_data do
    {
      date: '2013-07-01T19:59:37Z',
      end_date: '2013-07-09T19:59:37Z',
      "_links" => {image: {href: 'image_link'}},
      body: "one
      two
      three"
    }
  end
  subject { Event.new event_data }

  context '#start' do
    it { subject.date.should eql("2013-07-01T19:59:37Z") }
    it { subject.date(:raw).should eql("2013-07-01T19:59:37Z") }
    it { subject.date(:hour_minute_period).should eql(" 7:59PM") }
    it { subject.date(:short_date).should eql("1 Jul") }
  end

  context '#end' do
    it { subject.end_date.should eql("2013-07-09T19:59:37Z") }
  end

  context '#body' do
    it { subject.body.should eql(%w{one two three}) }
  end

  context '#image' do
    it { subject.image.should =~ /#{event_data[:image_ref]}/ }
  end

end
