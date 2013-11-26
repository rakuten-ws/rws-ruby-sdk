require 'spec_helper'
require 'rakuten_web_service'

describe RWS::Books::Genre do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:genre_id) { '000' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id,
      :genreId => genre_id
    }
  end
  let(:expected_json) do
    JSON.parse(fixture('books/genre_search.json'))
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).
      to_return(:body => fixture('books/genre_search.json'))

    RakutenWebService.configuration do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      @genre = RWS::Books::Genre.search(:genreId => genre_id).first
    end

    specify 'call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end
    specify 'has interfaces like hash' do
      expect(@genre['booksGenreName']).to eq(expected_json['current']['booksGenreName'])
      expect(@genre['genreLevel']).to eq(expected_json['current']['genreLevel'])
    end
    specify 'has interfaces like hash with snake case key' do
      expect(@genre['books_genre_name']).to eq(expected_json['current']['booksGenreName'])
      expect(@genre['genre_level']).to eq(expected_json['current']['genreLevel'])
    end
    specify 'has interfaces to get each attribute' do
      expect(@genre.id).to eq(expected_json['current']['booksGenreId'])
      expect(@genre.name).to eq(expected_json['current']['booksGenreName'])
    end
  end
end
