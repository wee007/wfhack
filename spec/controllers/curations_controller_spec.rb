require 'spec_helper'

describe CurationsController do
  describe 'GET #show' do
    let(:name) { 'Curation Name' }
    let(:slug) { 'curation-code' }
    let(:description) { 'Curation Description' }
    let(:centre_id) { 'bondijunction' }
    let(:curation) { Curation.new name: name, code: slug, description: description }
    let(:centre) { Centre.new name: 'Bondi Junction' }

    before do
      controller.stub(:service_map) {[ centre, curation ]}
      get :show, centre_id: centre_id, slug: slug
    end

    subject { response }

    it { should render_template 'show' }

    describe 'assignments' do
      specify { expect(assigns[:centre]).to be_a Centre }
      specify { expect(assigns[:curation]).to be_a Curation }
    end

    describe 'meta' do
      subject { controller.meta }
      its(:page_title) { should match %r{#{name}}i }
      its(:description) { should match %r{#{description}}i }
      its(:keys) { should include *%w[ id title twitter_title email_body image kind social_image ]}
    end
  end
end
