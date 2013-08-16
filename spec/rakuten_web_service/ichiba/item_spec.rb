# encoding: utf-8

require 'spec_helper'
require 'rakuten_web_service/ichiba/item'

describe RakutenWebService::Ichiba::Item do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :keyword => 'Ruby'
    }
  end

  before do
    response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).to_return(:body => response.to_json)

    response['page'] = 2
    response['first'] = 31
    response['last'] = 60
    @second_request = stub_request(:get, endpoint).
      with(:query => expected_query.merge(:page => 2)).
      to_return(:body => response.to_json)
  end

  context 'just call the search method' do
    before do
      @items = RakutenWebService::Ichiba::Item.search(
        :affiliate_id => affiliate_id,
        :application_id => application_id,
        :keyword => 'Ruby')
    end

    specify 'endpoint should not be called' do
      expect(@expected_request).to_not have_been_made
    end

    describe 'a respond object' do
      let(:expected_json) do
        response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
        response['Items'][0]['Item']
      end

      subject { @items.first }

      it { should be_a RakutenWebService::Ichiba::Item }
      specify 'shoud be access by key' do
        expect(subject['itemName']).to eq(expected_json['itemName'])
        expect(subject['item_name']).to eq(expected_json['itemName'])
      end 
      its(:name) { should eq(expected_json['itemName']) }
    end

    context 'after that, call each' do
      before do
        @items.each { |i| i }
      end

      specify 'endpoint should be called' do
        expect(@expected_request).to have_been_made.once
        expect(@second_request).to have_been_made.once
      end
    end
  end
end
