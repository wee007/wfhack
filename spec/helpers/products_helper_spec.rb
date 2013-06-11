require 'spec_helper'
describe ProductsHelper do
  let(:retailer_one) { mock :facet_value, code: 'one', name: 'one' }
  let(:retailer_two) { mock :facet_value, code: 'two', name: 'TWO' }
  let(:facets) do
    mock :facets, retailer: {
      values: [retailer_one, retailer_two]
    }, unavailable: nil
  end
  describe :facet_tag do
    it "returns nil if the requested facet is not available" do
      expect(facet_tag(:unavailable, facets)).to eq nil
    end
    let(:html) { Nokogiri::HTML(facet_tag(:retailer, facets)) }
    it "Makes a multi-select drop-down" do
      expect(html.xpath("//select/@multiple").text).to eq 'multiple'
    end
    it "Titleizes the option names" do
      expect(html.xpath("//option[@value='one']").text).to eq 'One'
      expect(html.xpath("//option[@value='two']").text).to eq 'Two'
    end
    it "Titleizes and pluralizes the placeholder text" do
      expect(html.xpath("//select/@data-placeholder").text).to eq 'Retailers'
    end
    it "Uses display_name as the placeholder text" do
      html = Nokogiri::HTML(facet_tag(:retailer, facets, 'override'))
      expect(html.xpath("//select/@data-placeholder").text).to eq 'override'
    end
  end
end

