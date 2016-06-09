# encoding: utf-8

require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Kobo::Ebook do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Kobo/EbookSearch/20140811' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :title => 'Ruby'
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
      response = JSON.parse(fixture('kobo/ebook_search_with_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(:query => expected_query).to_return(:body => response.to_json)
    end

    specify 'call endpoint when accessing results' do
      ebooks = RakutenWebService::Kobo::Ebook.search(:title => 'Ruby')
      expect(@expected_request).to_not have_been_made

      ebook = ebooks.first
      expect(@expected_request).to have_been_made.once
      expect(ebook).to be_a(RWS::Kobo::Ebook)
    end
  end

  describe '#genre' do
    let(:response) { JSON.parse(fixture('kobo/ebook_search_with_Ruby.json')) }

    specify 'respond Kobo::Genre object' do
      stub_request(:get, endpoint).with(:query => expected_query).
        to_return(:body => response.to_json)

      expected_item = response['Items'][0]['Item']
      RakutenWebService::Kobo::Genre.should_receive('new').with(expected_item['koboGenreId'])

      RakutenWebService::Kobo::Ebook.search(:title => 'Ruby').first.genre
    end
  end
end
