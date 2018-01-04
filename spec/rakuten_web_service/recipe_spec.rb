require 'spec_helper'

describe RakutenWebService::Recipe do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      categoryId: category_id
    }
  end
  let(:expected_query_without_category_id) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2'
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
      expect { RWS::Recipe.search(category_id: '10') }.to raise_error(NoMethodError)
    end
  end

  describe '.ranking' do
    context 'get ranking without category_id' do
      before do
        response = JSON.parse(fixture('recipe/ranking.json'))

        @expected_request = stub_request(:get, endpoint).
          with(query: expected_query_without_category_id).
          to_return(body: response.to_json)
      end

      subject { RakutenWebService::Recipe.ranking }

      it 'should call search without category_id' do
        subject.first

        expect(@expected_request).to have_been_made.once
      end
      it 'should return an array of Recipe' do
        expect(subject).to be_all { |r| r.is_a?(RWS::Recipe) }
      end
    end

    context 'get ranking with category_id' do
      let(:category_id) { '30' }

      before do
        response = JSON.parse(fixture('recipe/ranking.json'))

        @expected_request = stub_request(:get, endpoint).
          with(query: expected_query).
          to_return(body: response.to_json)
      end

      subject { RakutenWebService::Recipe.ranking(category_id) }

      it 'should call search with category_id' do
        subject.first

        expect(@expected_request).to have_been_made.once
      end
      it 'should return an array of Recipe' do
        expect(subject).to be_all { |r| r.is_a?(RWS::Recipe) }
      end
    end
  end
end
