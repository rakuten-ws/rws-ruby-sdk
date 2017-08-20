require "spec_helper"

describe RakutenWebService::BaseGenre do
  let(:dummy_endpoint) { 'https://api.example.com/dummy_genre' }
  let(:genre_id) { "1" }
  let(:expected_response) do
    {
      'current' => {
        dummyGenreId: 1,
        dummyGenreName: "CurrentGenre",
        genreLevel: 2
      },
      'children' => [
        {
          dummyGenreId: 1,
          dummyGenreName: "ChildOne",
          genreLevel: 3
        },
        {
          dummyGenreId: 2,
          dummyGenreName: "ChildTwo",
          genreLevel: 3
        }
      ],
      'parents' => [
        {
          dummyGenreId: 0,
          dummyGenreName: "TopGenre",
          genreLevel: 1
        }
      ],
      'brothers' => [
        {
          dummyGenreId: 3,
          dummyGenreName: "BrotherOne",
          genreLevel: 1
        }
      ]
    }
  end
  let!(:genre_class) do

    Class.new(RakutenWebService::BaseGenre) do
      endpoint "https://api.example.com/dummy_genre"
      set_resource_name 'dummy_genre'
      root_id 0
      attribute :dummyGenreId, :dummyGenreName, :genreLevel
    end
  end

  let!(:expected_request) do
    stub_request(:get, dummy_endpoint).
      with(query: {
        applicationId: "DUMMY_APPLICATION_ID",
        affiliateId: "DUMMY_AFFILIATE_ID",
        formatVersion: 2,
        dummyGenreId: genre_id
      }).
      to_return(body: expected_response.to_json)
  end

  before do
    RakutenWebService.configure do |c|
      c.application_id = "DUMMY_APPLICATION_ID"
      c.affiliate_id = "DUMMY_AFFILIATE_ID"
    end
  end

  describe ".genre_id_key" do
    it { expect(genre_class.genre_id_key).to be_eql(:dummy_genre_id) }
  end

  describe ".root_id" do
    it { expect(genre_class.root_id).to be_eql(0) }
  end

  describe ".new" do
    specify "should call search" do
      genre_class.new(genre_id)

      expect(expected_request).to have_been_made.once
    end
  end

  describe ".[]" do
    specify "should call search only once as intializing twice" do
      2.times { genre_class[genre_id] }

      expect(expected_request).to have_been_made.once
    end
  end
end