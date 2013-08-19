require 'spec_helper'
require 'rakuten_web_service/ichiba/ranking'

describe RakutenWebService::Ichiba::RankingItem do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Ranking/20120927' }
  let(:affiliate_id) { 'affiliate_id' }
  let(:application_id) { 'application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id, :applicationId => application_id
    }
  end

  before do 
    response = JSON.parse(fixture('ichiba/ranking_search.json'))
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).to_return(:body => response.to_json)

    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do 
      @ranking_items = RakutenWebService::Ichiba::RankingItem.search({}).first
    end

    specify 'should call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end
  end

end
