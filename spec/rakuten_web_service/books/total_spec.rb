require 'spec_helper'

describe RakutenWebService::Books::Total do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404' }
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
      response = JSON.parse(fixture('books/total_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    specify 'call endpoint when accessing results' do
      items = RakutenWebService::Books::Total.search(keyword: 'Ruby')
      expect(@expected_request).to_not have_been_made

      items.first
      expect(@expected_request).to have_been_made.once
    end
  end
end
