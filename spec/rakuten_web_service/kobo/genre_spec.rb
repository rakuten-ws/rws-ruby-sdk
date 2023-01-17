require 'spec_helper'

describe RWS::Kobo::Genre do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Kobo/GenreSearch/20131010' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:genre_id) { '101' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      koboGenreId: genre_id
    }
  end
  let(:expected_json) do
    JSON.parse(fixture('kobo/genre_search.json'))
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
      @genre = RWS::Kobo::Genre.search(koboGenreId: genre_id).first
    end

    specify 'call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end
  end

  describe '#search' do
    before do
      stub_request(:get, endpoint).with(query: expected_query).
        to_return(body: expected_json.to_json)
    end

    context 'Without arguments' do
      specify 'should call RWS::Kobo::Ebook.search with specifying genre id' do
        expect(RWS::Kobo::Ebook).to receive(:search).with({RWS::Kobo::Genre.genre_id_key => genre_id})

        RWS::Kobo::Genre.root.search
      end
    end
    context 'With arguments' do
      specify 'should call RWS::Kobo::Ebook.search with given arguments and genre id' do
        options = { title: 'Ruby' }
        expect(RWS::Kobo::Ebook).to receive(:search).with({title: 'Ruby', RWS::Kobo::Genre.genre_id_key => genre_id})

        RWS::Kobo::Genre.root.search(options)
      end
    end
  end
end
