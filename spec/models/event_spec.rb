require 'spec_helper'

describe Event do

  let :event_data do
    {
      occurrences: [{start: '2013-07-01T19:59:37Z', finish: '2013-07-09T19:59:37Z'}],
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

  context '#occurrences' do
    it 'should adjust the displayed date based on the centre timezone' do
      subject.timezone = "Australia/Queensland"
      # Queensland time is UTC + 10 hours
      subject.start_date(:hour_minute_period).should eql(" 5:59am") 
      subject.start_date(:full_date).should eql("2 Jul 2013,  5:59am") 
    end
   
  end

end
