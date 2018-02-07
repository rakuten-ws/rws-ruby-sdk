require 'spec_helper'

describe RakutenWebService::Books::Magazine do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksMagazine/Search/20170404' }
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
      response = JSON.parse(fixture('books/magazine_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    specify 'call endpoint when accessing results' do
      magazines = RakutenWebService::Books::Magazine.search(keyword: 'Ruby')
      expect(@expected_request).to_not have_been_made

      magazine = magazines.first
      expect(@expected_request).to have_been_made.once
      expect(magazine).to be_a(RWS::Books::Magazine)
    end
  end

  context 'When using Books::Total.search' do
    let(:magazine) do
      RWS::Books::Magazine.new(jan: '12345')
    end

    before do
      @expected_request = stub_request(:get, endpoint).
        with(query: { affiliateId: affiliate_id, applicationId: application_id, formatVersion: '2', jan: '12345' }).
        to_return(body: { Items: [ { title: 'foo' } ] }.to_json)
    end

    specify 'retrieves automatically if accessing the value of lack attribute' do
      expect(magazine.title).to eq('foo')
      expect(@expected_request).to have_been_made.once
    end
  end
end
