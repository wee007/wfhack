require 'spec_helper'
describe ProductsHelper do
  def build_params_hash(uri)
    hash = {}.with_indifferent_access
    qs = uri.query.split("&")
    qs.each do |q|
      k,v = q.split("=")
      if k.ends_with?("%5B%5D")
        field = k.sub("%5B%5D", "")
        hash[field] ||= []
        hash[field] << v
      else
        hash[k]=v
      end
    end
    hash
  end
  describe :facet_remove_link do
    before(:each) do
      # Filter all the things!
      params = { centre_id: 'bondijunction',
        super_cat: 'womens-fashion-accessories',
        category: 'womens-clothing', sub_category: 'womens-dresses',
        type: 'w-dresses-casual', colour: %w(Reds Blues),
        size: %w(S M L), brand: %w(surfstitch forever21),
        price: '10-350', on_sale: 'true' }.with_indifferent_access
      helper.stub(:params).and_return params
    end
    it 'removes Reds from the colours list' do
      uri = URI(helper.facet_remove_link 'colour', 'Reds')
      expect(build_params_hash(uri)[:colour]).to eq ['Blues']
    end
    it 'removes M from the sizes list' do
      uri = URI(helper.facet_remove_link 'size', 'M')
      expect(build_params_hash(uri)[:size]).to eq %w(S L)
    end
    it 'removes the on_sale filter' do
      uri = URI(helper.facet_remove_link 'on_sale', '')
      expect(build_params_hash(uri)[:on_sale]).to eq nil
    end
    it 'removes sub_category, colour, size and type fields when removing a category' do
      uri = URI(helper.facet_remove_link 'category', 'womens-clothing')
      %w(category sub_category colour size type).each do |f|
        expect(build_params_hash(uri)[f]).to eq nil
      end
      # But not the other fields
      expect(build_params_hash(uri)[:on_sale]).to eq 'true'
    end
    it 'removes category, sub_category, colour, size and type fields when removing a super category' do
      uri = URI(helper.facet_remove_link 'super_cat', 'womens-fashion-accessories')
      %w(super_cat category sub_category colour size type).each do |f|
        expect(build_params_hash(uri)[f]).to eq nil
      end
      # But not the other fields
      expect(build_params_hash(uri)[:price]).to eq '10-350'
    end
  end
end
