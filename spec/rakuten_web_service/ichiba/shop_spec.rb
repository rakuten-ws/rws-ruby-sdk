require 'spec_helper'

describe RakutenWebService::Ichiba::Shop do
  let(:params) do
    { 'shopName' => 'Hoge Shop',
      'shopCode' => 'hogeshop',
      'shopUrl' => 'http://www.rakuten.co.jp/hogeshop' }
  end
  let(:shop) { RakutenWebService::Ichiba::Shop.new(params) }
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      'affiliateId' => affiliate_id,
      'applicationId' => application_id,
      'formatVersion' => '2',
      'shopCode' => 'hogeshop'
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.new' do
    specify 'returned object should have methods to fetch values' do
      expect(shop.name).to eq('Hoge Shop')
      expect(shop.code).to eq('hogeshop')
      expect(shop.url).to eq('http://www.rakuten.co.jp/hogeshop')
    end
  end

  describe '#items' do
    let(:response) do
      { 'Items' => [] }
    end

    before do
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    specify 'call the endpoint with the shopCode' do
      shop.items.first

      expect(@expected_request).to have_been_made
    end
  end
end
