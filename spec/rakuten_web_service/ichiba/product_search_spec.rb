# encoding: utf-8
require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Ichiba::Product do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Product/Search/20140305' }
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
    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      response = JSON.parse(fixture('ichiba/product_search.json'))
      @expected_request = stub_request(:get, endpoint).
        with(:query => expected_query).to_return(:body => response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      response['pageCount'] = 2
      @second_request = stub_request(:get, endpoint).
        with(:query => expected_query.merge(:page => 2)).
        to_return(:body => response.to_json)
    end

    subject { RakutenWebService::Ichiba::Product.search(:keyword => 'Ruby') }

    specify '' do
      expect(subject).to have(60).things
    end
  end
end
