# encoding: utf-8

require 'spec_helper'
require 'rakuten_web_service'

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
  let(:expected_json) do
    JSON.parse(fixture('ichiba/genre_search.json'))
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

  describe '.new' do
    before do 
      RakutenWebService::Ichiba::Genre.search(:genreId => genre_id).first
    end

    context 'given genre_id' do
      context 'the genre_id has been already fetched' do
        before do
          @genre = RakutenWebService::Ichiba::Genre.new(genre_id)
        end

        subject { @genre }

        specify 'should call the API only once' do
          expect(@expected_request).to have_been_made.once
          expect(@expected_request).to_not have_been_made.twice
        end
        specify 'should be access by key' do
          expect(subject['genreName']).to eq(expected_json['current']['genreName'])
          expect(subject['genre_name']).to eq(expected_json['current']['genreName'])
        end
      end

      context 'the genre_id has not fetched yet' do
        let(:new_genre_id) { 1981 }
        before do
          @expected_request = stub_request(:get, endpoint).
            with(:query => { 
                 :affiliateId => affiliate_id,
                 :applicationId => application_id,
                 :genreId => new_genre_id }).
            to_return(:body => { :genreId => new_genre_id,
                                 :genreName => 'DummyGenre',
                                 :genreLevel => 3 }.to_json)

          @genre = RakutenWebService::Ichiba::Genre.new(new_genre_id)
        end

        specify 'should call the API' do
          expect(@expected_request).to have_been_made.once
        end
      end
    end
  end

  describe '.root' do
    before do
      @genre = RakutenWebService::Ichiba::Genre.new(0)
    end

    specify 'should be equal genre object with id 0' do
      expect(RakutenWebService::Ichiba::Genre.root).
        to eq(RakutenWebService::Ichiba::Genre[0])
    end
  end
end
