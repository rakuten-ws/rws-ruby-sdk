require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Ichiba::Shop do
  describe '.new' do
    let(:params) do
      { 'shopName' => 'Hoge Shop',
        'shopCode' => 'hogeshop',
        'shopUrl' => 'http://www.rakuten.co.jp/hogeshop' }
    end
    let(:shop) { RakutenWebService::Ichiba::Shop.new(params) }

    subject 'returned object should have methods to fetch values' do
      expect(shop.name).to eq('Hoge Shop')
      expect(shop.code).to eq('hogeshop')
      expect(shop.url).to eq('http://www.rakuten.co.jp/hogeshop')
    end
  end
end
