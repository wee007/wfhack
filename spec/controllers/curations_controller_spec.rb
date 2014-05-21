require 'spec_helper'

describe CurationsController do
  describe 'GET #show' do
    let(:name) { 'Curation Name' }
    let(:slug) { 'curation-code' }
    let(:description) { 'Curation Description' }
    let(:centre_id) { 'bondijunction' }
    let(:centre_name) { 'Bondi Junction' }
    let(:curation) { Curation.new name: name, code: slug, description: description }
    let(:centre) { Centre.new name: centre_name, state: 'NSW' }

    class << self
      def get_centre_curation
        Proc.new {
          controller.stub(:service_map) {[ curation, centre ]}
          get :show, slug: slug, centre_id: centre_id
        }
      end

      def get_national_curation
        Proc.new {
          controller.stub(:service_map) {[ curation, [ centre ]]}
          get :show, slug: slug
        }
      end
    end

    describe 'rendered' do
      context 'when curation exists' do
        before &get_centre_curation
        subject { response }
        it { should render_template 'show' }
      end

      context 'when curation not found' do
        before { controller.stub :service_map }
        specify { expect { get :show, slug: slug }.to raise_exception }
      end
    end

    describe 'assignments' do
      context 'when centre collection (params[:centre_id] present)' do
        before &get_centre_curation

        describe '@curation' do
          subject { assigns :curation }
          it { should be_a Curation }
        end

        describe '@centre' do
          subject { assigns :centre }
          it { should be_a Centre }
        end
      end

      context 'when national collection (params[:centre_id] not present)' do
        before &get_national_curation

        describe '@curation' do
          subject { assigns :curation }
          it { should be_a Curation }
        end

        describe '@centre_by_state' do
          subject { assigns :centres_by_state }
          it { should be_a Hash }
        end

        describe '@centre' do
          subject { assigns :centre }
          it { should be_nil }
        end
      end
    end

    describe '#meta' do
      subject { controller.meta }

      context 'when centre collection' do
        before &get_centre_curation
        its(:page_title) { should match %r{#{name}}i }
        its(:page_title) { should match %r{at\s#{centre_name}$}i }
        its(:description) { should match %r{#{description}}i }
        its(:keys) { should include *%w[ id title twitter_title email_body image kind social_image ]}
      end

      context 'when national collection' do
        before &get_national_curation
        its(:page_title) { should match %r{#{name}}i }
        its(:page_title) { should match %r{at\swestfield$}i }
        its(:description) { should match %r{#{description}}i }
        its(:keys) { should include *%w[ id title twitter_title email_body image kind social_image ]}
      end
    end
  end
end
