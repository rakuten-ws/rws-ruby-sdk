require 'spec_helper'

describe RakutenWebService::Books::CD do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksCD/Search/20130522' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :keyword => 'Ruby'
    }
  end

  before do
    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      response = JSON.parse(fixture('books/cd_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(:query => expected_query).to_return(:body => response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      @second_request = stub_request(:get, endpoint).
        with(:query => expected_query.merge(:page => 2)).
        to_return(:body => response.to_json)
    end

    specify 'call endpoint when accessing results' do
      cds = RakutenWebService::Books::CD.search(:keyword => 'Ruby')
      expect(@expected_request).to_not have_been_made

      cd = cds.first
      expect(@expected_request).to have_been_made.once
      expect(cd).to be_a(RWS::Books::CD)
    end
  end

  context 'When using Books::Total.search' do
    let(:cd) do
      RWS::Books::CD.new(:jan => '12345')
    end

    before do
      @expected_request = stub_request(:get, endpoint).
        with(:query => { :affiliateId => affiliate_id, :applicationId => application_id, :jan => '12345' }).
        to_return(:body => { :Items => [ { :Item => { :title => 'foo' } } ] }.to_json)
    end

    specify 'retrieves automatically if accessing the value of lack attribute' do
      expect(cd.title).to eq('foo')
      expect(@expected_request).to have_been_made.once
    end
  end
end
