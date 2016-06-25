require 'spec_helper'

describe RakutenWebService::Recipe do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :categoryId => category_id
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    it 'should not be called' do
      expect { RWS::Recipe.search(category_id: '10') }.to raise_error
    end
  end

  describe '.ranking' do
    let(:category_id) { '30' }

    before do
      response = JSON.parse(fixture('recipe/ranking.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).
        to_return(body: response.to_json)
    end

    subject { RakutenWebService::Recipe.ranking(category_id) }

    it 'should call search with category id' do
      subject.first

      expect(@expected_request).to have_been_made.once
    end
    it 'shoudl return an array of Reciep' do
      expect(subject).to be_all { |r| r.is_a?(RWS::Recipe) }
    end
  end
end
