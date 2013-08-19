# encoding: utf-8

require 'spec_helper'
require 'rakuten_web_service/ichiba/genre'

describe RakutenWebService::Ichiba::Genre do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20120723' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:genre_id) { 0 }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :genreId => genre_id
    }
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).
      to_return(:body => fixture('ichiba/genre_search.json'))

    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    let(:expected_json) do
      JSON.parse(fixture('ichiba/genre_search.json'))
    end

    before do
      @genre = RakutenWebService::Ichiba::Genre.search(:genreId => genre_id).first
    end

    subject { @genre }

    specify 'should call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end
    specify 'should be access by key' do
      expect(subject['genreName']).to eq(expected_json['current']['genreName'])
      expect(subject['genre_name']).to eq(expected_json['current']['genreName'])
    end
    its(:name) { should eq(expected_json['current']['genreName']) }
  end
end
