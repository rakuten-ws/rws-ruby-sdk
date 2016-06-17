require 'spec_helper'

describe RakutenWebService::Recipe::Category do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20121121' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :categoryType => category_type
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.large_categories' do
    let(:category_type) { 'large' }

    before do
      response = JSON.parse(fixture('recipe/category.json'))

      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    subject { RakutenWebService::Recipe::Category.large_categories }

    it 'should return' do
      expect(subject).to be_a(Array)
    end
  end
end
