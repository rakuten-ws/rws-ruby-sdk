require 'spec_helper'

describe RakutenWebService::Ichiba::Product do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Product/Search/20170426' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      keyword: 'Ruby'
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      response = JSON.parse(fixture('ichiba/product_search.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      response['pageCount'] = 2
      @second_request = stub_request(:get, endpoint).
        with(query: expected_query.merge(page: 2)).
        to_return(body: response.to_json)
    end

    subject { RakutenWebService::Ichiba::Product.search(keyword: 'Ruby') }

    specify '' do
      expect(subject.count).to eq(30)
    end

    describe 'For an response' do
      let(:expected_product) do
        JSON.parse(fixture('ichiba/product_search.json'))['Products'].first
      end
      let(:product) { RakutenWebService::Ichiba::Product.search(keyword: 'Ruby').first }

      specify 'should have methods to respond keys following with "product"' do
        expect(product.id).to eq(expected_product['productId'])
        expect(product.name).to eq(expected_product['productName'])
        expect(product.url_pc).to eq(expected_product['productUrlPC'])
        expect(product.url_mobile).to eq(expected_product['productUrlMobile'])
        expect(product.caption).to eq(expected_product['productCaption'])
      end
      specify 'should have genre method' do
        expect(RakutenWebService::Ichiba::Genre).to receive(:new).with(expected_product['genreId'])

        product.genre
      end
    end
  end
end
