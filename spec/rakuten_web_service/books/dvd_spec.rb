require 'spec_helper'

describe RakutenWebService::Books::DVD do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksDVD/Search/20170404' }
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
      response = JSON.parse(fixture('books/dvd_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      @second_request = stub_request(:get, endpoint).
        with(query: expected_query.merge(page: 2)).
        to_return(body: response.to_json)
    end

    specify 'call endpoint when accessing results' do
      dvds = RakutenWebService::Books::DVD.search(keyword: 'Ruby')
      expect(@expected_request).to_not have_been_made

      dvd = dvds.first
      expect(@expected_request).to have_been_made.once
      expect(dvd).to be_a(RWS::Books::DVD)
    end
  end

  context 'When using Books::Total.search' do
    let(:dvd) do
      RWS::Books::DVD.new(jan: '12345')
    end

    before do
      @expected_request = stub_request(:get, endpoint).
        with(query: { affiliateId: affiliate_id, applicationId: application_id, formatVersion: '2', jan: '12345' }).
        to_return(body: { Items: [ { title: 'foo' } ] }.to_json)
    end

    specify 'retrieves automatically if accessing the value of lack attribute' do
      expect(dvd.title).to eq('foo')
      expect(@expected_request).to have_been_made.once
    end
  end
end
