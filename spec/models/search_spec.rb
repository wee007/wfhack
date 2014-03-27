require 'spec_helper'

describe Search do

  context 'Centre Information' do
    describe "When receiving only one result, which is a centre information result" do
      it "should get the centre from the centre service" do
        data = JSON.parse '{"term":"hours","results":{"centre_information":[{"id":"centre-hours hours time open trading trading-hours opening-hours opening-times centre-hours store-hours times shopping-times australia-day anzac-day boxing-day canberra-day christmas christmas-day christmas-eve easter easter-monday easter-saturday easter-sunday easter-tuesday eight-hours-day family-\u0026-community-day good-friday labour-day march-public-holiday may-day melbourne-cup melbourne-cup-day new-years-day new-years-eve NYE picnic-day queens-birthday Western-Australia-Day Xmas","term":"centrehours hours time open trading tradinghours openinghours openingtimes centrehours storehours times shoppingtimes australiaday anzacday boxingday canberraday christmas christmasday christmaseve easter eastermonday eastersaturday eastersunday eastertuesday eighthoursday familycommunityday goodfriday labourday marchpublicholiday mayday melbournecup melbournecupday newyearsday newyearseve nye picnicday queensbirthday westernaustraliaday xmas","score":-366,"display":"Shopping hours","result_type":"centre_information","attributes":{"path":"/sydney/hours"}}]}}'
        search = Search.new(data)
        expect(search.hard_redirect?).to be_true
        expect(search.first_result_uri_path).to eql("/sydney/hours")
      end
    end
  end

  context 'Centre Information' do
    describe "When receiving only multiple results, including a centre information result" do
      it "should get the centre from the centre service" do
        data = JSON.parse '{"term":"easter","results":{"events":[{"id":3299,"term":"celebrate easter with laduree ladurees easter chocolate collection is available instore now","score":-11,"display":"Celebrate Easter with Ladurée","result_type":"event","attributes":{"id":3299}},{"id":3336,"term":"lulu bell childrens high tea at the tea salon this easter school holidays treat little ones to ribbon sandwiches and pink cupcakes at the tea salons lulu bell childrens high tea hosted by author belinda murrell","score":-130,"display":"Lulu Bell Children’s High Tea at The Tea Salon","result_type":"event","attributes":{"id":3336}},{"id":2846,"term":"lindt popup stores at westfield sydney this easter we are making it easier for you to get your hands on the infamous lindt gold bunny with two exciting new lindt easter popup stores open in westfield sydney the first store located on level 4 will be an easter oasis with shelves full of your favourite lindt easter treats and some fantastic new easter goodies for the 2014 season including the brand new hazelnut gold bunny and the noccior egg the second store located in the myer food court atrium also houses a great range including lindt pick and mix chocolates allowing you to create your every own personalised easter gift","score":-547,"display":"Lindt Pop-up Stores at Westfield Sydney","result_type":"event","attributes":{"id":2846}}],"centre_information":[{"id":"centre-hours hours time open trading trading-hours opening-hours opening-times centre-hours store-hours times shopping-times australia-day anzac-day boxing-day canberra-day christmas christmas-day christmas-eve easter easter-monday easter-saturday easter-sunday easter-tuesday eight-hours-day family-\u0026-community-day good-friday labour-day march-public-holiday may-day melbourne-cup melbourne-cup-day new-years-day new-years-eve NYE picnic-day queens-birthday Western-Australia-Day Xmas","term":"centrehours hours time open trading tradinghours openinghours openingtimes centrehours storehours times shoppingtimes australiaday anzacday boxingday canberraday christmas christmasday christmaseve easter eastermonday eastersaturday eastersunday eastertuesday eighthoursday familycommunityday goodfriday labourday marchpublicholiday mayday melbournecup melbournecupday newyearsday newyearseve nye picnicday queensbirthday westernaustraliaday xmas","score":-366,"display":"Shopping hours","result_type":"centre_information","attributes":{"path":"/sydney/hours"}}]}}'
        search = Search.new(data)
        expect(search.hard_redirect?).to be_false 
      end
    end
  end

end