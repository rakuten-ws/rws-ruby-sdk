require 'spec_helper'

describe RWS::Books::Genre do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:genre_id) { '000' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      booksGenreId: genre_id
    }
  end
  let(:expected_json) do
    JSON.parse(fixture('books/genre_search.json'))
  end

  after do
    RWS::Books::Genre.instance_variable_set('@repository', {})
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(query: expected_query).
      to_return(body: expected_json.to_json)

    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      @genre = RWS::Books::Genre.search(booksGenreId: genre_id).first
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

  describe '.new' do
    let(:genre_id) { '007' }
    let(:expected_json) do
      {
        current: {
                  booksGenreId: genre_id,
                  booksGenreName: 'DummyGenre',
                  genreLevel: '2'
                }
      }
    end

    before do
      @genre = RWS::Books::Genre.new(param)
    end

    context 'given a genre id' do
      let(:param) { genre_id }

      specify 'only call endpint only at the first time to initialize' do
        RWS::Books::Genre.new(param)

        expect(@expected_request).to have_been_made.once
      end
    end
  end

  describe '.root' do
    specify 'alias of constructor with the root genre id "000"' do
      expect(RWS::Books::Genre).to receive(:new).with('000')

      RWS::Books::Genre.root
    end
  end

  describe '#children' do
    context 'When get search method' do
      before do
        @genre = RWS::Books::Genre.search(booksGenreId: genre_id).first
      end

      specify 'are Books::Genre objects' do
        expect(@genre.children).to be_all { |child| child.is_a? RWS::Books::Genre }
        expect(@genre.children).to be_all do |child|
          expected_json['children'].any? { |c| c['booksGenreId'] == child['booksGenreId'] }
        end
      end
    end

    context 'when the genre object has no children information' do
      specify 'call the endpoint to get children' do
        genre = RWS::Books::Genre.new(booksGenreId: genre_id)
        genre.children

        expect(@expected_request).to have_been_made.once
      end
    end
  end

  describe '#search' do
    before do
      @genre = RWS::Books::Genre.new(booksGenreId: genre_id)
    end

    context 'if the genre_id starts with "001"' do
      let(:genre_id) { '001001' }

      specify 'delegate Books::Book.search' do
        expect(RWS::Books::Book).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "002"' do
      let(:genre_id) { '002101' }

      specify 'delegate Books::CD.search' do
        expect(RWS::Books::CD).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "003"' do
      let(:genre_id) { '003201' }

      specify 'delegate Books::DVD.search' do
        expect(RWS::Books::DVD).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "004"' do
      let(:genre_id) { '004301' }

      specify 'delegate Books::Software.search' do
        expect(RWS::Books::Software).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "005"' do
      let(:genre_id) { '005401' }

      specify 'delegate Books::ForeignBook.search' do
        expect(RWS::Books::ForeignBook).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "006"' do
      let(:genre_id) { '006501' }

      specify 'delegate Books::Game.search' do
        expect(RWS::Books::Game).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end

    context 'if the genre_id starts with "007"' do
      let(:genre_id) { '007601' }

      specify 'delegate Books::Magazine.search' do
        expect(RWS::Books::Magazine).to receive(:search).with(booksGenreId: genre_id)

        @genre.search
      end
    end
  end
end
