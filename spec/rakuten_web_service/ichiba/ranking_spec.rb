require 'spec_helper'
require 'rakuten_web_service/ichiba/ranking'

describe RakutenWebService::Ichiba::RankingItem do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Ranking/20170628' }
  let(:affiliate_id) { 'affiliate_id' }
  let(:application_id) { 'application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2'
    }
  end

  before do
    response = JSON.parse(fixture('ichiba/ranking_search.json'))
    @expected_request = stub_request(:get, endpoint).
      with(query: expected_query).to_return(body: response.to_json)

    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    let(:expected_json) do
      response = JSON.parse(fixture('ichiba/ranking_search.json'))
      response['Items'][0]
    end

    before do
      @ranking_item = RakutenWebService::Ichiba::RankingItem.search({}).first
    end

    subject { @ranking_item }

    specify 'should call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end
    specify 'should be access by key' do
      expect(subject['itemName']).to eq(expected_json['itemName'])
      expect(subject['item_name']).to eq(expected_json['itemName'])
    end

    describe '#rank' do
      subject { super().rank }
      it { is_expected.to eq(1) }
    end

    describe '#name' do
      subject { super().name }
      it { is_expected.to eq(expected_json['itemName']) }
    end
  end

end
