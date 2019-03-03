require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Travel::Hotel do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: 2,
      largeClassCode: 'japan',
      middleClassCode: 'hokkaido',
      smallClassCode: 'sapporo',
      detailClassCode: 'A'
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    let(:query) do
      {
      largeClassCode: 'japan',
      middleClassCode: 'hokkaido',
      smallClassCode: 'sapporo',
      detailClassCode: 'A'
      }
    end

    before do
      response = JSON.parse(fixture('travel/simple_hotel_search.json'))
      @expected_request = stub_request(:get, endpoint)
        .with(query: expected_query).to_return(body: response.to_json)

      response['pagingInfo']['page'] = 2
      response['pagingInfo']['pageCount'] = 2
      response['pagingInfo']['first'] = 31
      response['pagingInfo']['last'] = 60
      @second_request = stub_request(:get, endpoint)
        .with(query: expected_query.merge(page: 2))
        .to_return(body: response.to_json)
    end

    let(:results) { RakutenWebService::Travel::Hotel.search(query) }
    let(:first) { results.first }

    specify 'responds an array of RWS::Travel::Hotel object' do
      expect(first).to be_a(RakutenWebService::Travel::Hotel)
    end
    specify 'respond object has 2 methods representing basic info and rating info ' do
      expect(first.basic_info).to eq(first['hotelBasicInfo'])
      expect(first.rating_info).to eq(first['hotelRatingInfo'])
    end
    specify 'should have 60 objects by getting responses automatically' do
      expect(results.to_a.size).to eql 30
    end
  end
end
