require 'spec_helper'

describe Event do

  let :event_data do
    {
      occurrences: [{start: '2013-07-01T19:59:37Z', finish: '2013-07-09T19:59:37Z'}],
      # date: '2013-07-01T19:59:37Z',
      # end_date: '2013-07-09T19:59:37Z',
      "_links" => {image: {href: 'image_link'}},
      body: "one
      two
      three"
    }
  end
  subject { Event.new event_data }

  context '#start_date' do
    it { subject.start_date.should eql("2013-07-01T19:59:37Z") }
    it { subject.start_date(:raw).should eql("2013-07-01T19:59:37Z") }
    it { subject.start_date(:hour_minute_period).should eql(" 7:59pm") }
    it { subject.start_date(:short_date).should eql("1 Jul") }
    it { subject.start_date(:full_date).should eql("1 Jul 2013,  7:59pm") }
  end

  context '#end_date' do
    it { subject.end_date.should eql("2013-07-09T19:59:37Z") }
  end

  context '#body' do
    it { subject.body.should eql(%w{one two three}) }
  end

  context '#image' do
    it { subject.image.should =~ /#{event_data[:image_ref]}/ }
  end

end
