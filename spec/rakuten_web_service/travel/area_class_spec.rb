require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Travel::AreaClass do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id
    }
  end
  let(:response) { JSON.parse(fixture('travel/area_class.json')) }
  let!(:expected_request) do
    stub_request(:get, endpoint).
     with(:query => expected_query).to_return(:body => response.to_json)
  end

  before do
    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      @area_class = RakutenWebService::Travel::AreaClass.search({}).first
    end

    specify 'respond largeClass' do
      expect(@area_class['largeClassCode']).to eq('japan')
      expect(@area_class['largeClassName']).to eq('日本')
    end
  end
end
