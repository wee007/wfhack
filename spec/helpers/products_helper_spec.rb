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
    let(:options) { {multiple: true} }
    let(:html) { Nokogiri::HTML(facet_tag(:retailer, facets, options)) }
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
    describe "with display_name override" do
      let(:options) { {display_name: 'override'} }
      it "Uses display_name as the placeholder text" do
        expect(html.xpath("//select/@data-placeholder").text).to eq 'override'
      end
    end
  end
  describe :category_facet_tag do
    describe 'for types' do
      let(:facets) { Hashie::Mash.new(super_cat: mock(:facet),
        type: mock(:facet), category: mock(:facet), sub_category: mock(:facet)) }
      it "renders a multi-valued facet tag" do
        helper.should_receive(:facet_tag).with('type', facets, hash_including(multiple: true))
        helper.category_facet_tag facets
      end
    end
    describe 'for super_categories' do
      let(:facets) { Hashie::Mash.new(super_cat: mock(:facet)) }
      it "renders a single-valued facet tag" do
        helper.should_receive(:facet_tag).with('super_cat', facets, hash_including(multiple: false))
        helper.category_facet_tag facets
      end
    end
  end
  describe 'applied_category_filter_tag' do
    before :each do
      helper.stub(:params).and_return({centre_id: 'bondijunction'}.with_indifferent_access)
    end
    let(:super_cat) {
      Hashie::Mash.new type: 'super_cat', value: 'fashion', title: 'Fashion'
    }
    let(:applied_filters) { Hashie::Mash.new categories: {super_cat: super_cat} }
    it 'returns nil if the requested filter is not applied' do
      expect(helper.applied_category_filter_tag('category',applied_filters)).to eq nil
    end
    let(:tag) { helper.applied_category_filter_tag('super_cat',applied_filters) }
    let(:link) { Nokogiri::HTML(tag).xpath("//a") }
    it 'sets data-category-type to the category type' do
      expect(link.attr('data-category-type').value).to eq 'super_cat'
    end
    it 'sets data-category-code to the category value' do
      expect(link.attr('data-category-code').value).to eq 'fashion'
    end
    it 'sets link text to the category title' do
      expect(link.text).to eq 'Fashion'
    end
  end
end

