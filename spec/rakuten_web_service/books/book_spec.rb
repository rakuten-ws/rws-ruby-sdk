require 'spec_helper'

describe RakutenWebService::Books::Book do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      title: 'Ruby'
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
      response = JSON.parse(fixture('books/book_search_with_keyword_Ruby.json'))
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
      books = RakutenWebService::Books::Book.search(title: 'Ruby')
      expect(@expected_request).to_not have_been_made

      books.first
      expect(@expected_request).to have_been_made.once
    end
  end

  describe "#genre_information" do
    before do
      response = JSON.parse(fixture('books/book_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    subject { RakutenWebService::Books::Book.search(title: 'Ruby') }

    it "responds GenreInformation object" do
      expect(subject.genre_information).to be_a(RakutenWebService::GenreInformation)
    end


    describe "its attributes" do
      subject { super().genre_information }

      it "have current genre" do
        expect(subject.current).to be_a(RakutenWebService::Books::Genre)
        expect(subject.current.item_count).to eq('119')
      end
    end
  end

  describe '#genre' do
    let(:response) { JSON.parse(fixture('books/book_search_with_keyword_Ruby.json')) }

    before do
      res = response.dup
      res['page'] = 1
      res['first'] = 1
      res['last'] = 30

      stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: res.to_json)
    end

    specify 'genretes RWS::Books::Genre object' do
      book = RWS::Books::Book.search(title: 'Ruby').first

      expect(RWS::Books::Genre).to receive(:new).with(response['Items'][0]['booksGenreId'])
      expect(book.genre).to be_a(Array)
    end

    specify 'generate an array of Books::Genre object if books_genre_id includes 2 ids' do
      genre_id = '001004008007/001021001010'
      book = RWS::Books::Book.new(booksGenreId: genre_id)
      genre_id.split('/').each do |id|
        expect(RWS::Books::Genre).to receive(:new).with(id)
      end

      expect(book.genres).to be_a(Array)
    end
  end

  context 'When using Books::Total.search' do
    let(:book) do
      RWS::Books::Book.new(isbn: '12345')
    end

    before do
      @expected_request = stub_request(:get, endpoint).
        with(query: { affiliateId: affiliate_id, applicationId: application_id, formatVersion: '2', isbn: '12345' }).
        to_return(body: { Items: [ { title: 'foo' } ] }.to_json)
    end

    specify 'retrieves automatically if accessing the value of lack attribute' do
      expect(book.title).to eq('foo')
      expect(@expected_request).to have_been_made.once
    end
  end
end
