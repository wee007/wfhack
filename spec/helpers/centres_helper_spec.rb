require 'spec_helper'
describe CentresHelper do

  describe :social_media do
    context "when no social media exists" do
      before( :each ) do
        @centre = double( :centre,
          centre_id: 'chatswood',
          facebook: '',
          twitter: '',
          google_plus: '',
          instagram: '',
          pinterest: '',
          youtube: ''
        )
      end

      it "should not return any social media URLs" do
        helper.social_media.should eq([])
      end
    end

    context "when a social media exists" do
      before( :each ) do
        @centre = double( :centre,
          centre_id: 'chatswood',
          facebook: 'http://facebook.com',
          twitter: '',
          google_plus: 'http://plus.google.com',
          instagram: '',
          pinterest: 'http://pinterest.com',
          youtube: ''
        )

        @social_media = [
          'http://facebook.com',
          'http://plus.google.com',
          'http://pinterest.com'
        ]
      end

      it "should return some social media URLs" do
        helper.social_media.should eq( @social_media )
      end
    end
  end

end
