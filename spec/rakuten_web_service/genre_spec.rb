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
          dummyGenreId: 2,
          dummyGenreName: "ChildOne",
          genreLevel: 3
        },
        {
          dummyGenreId: 3,
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
          dummyGenreId: 4,
          dummyGenreName: "BrotherOne",
          genreLevel: 1
        }
      ]
    }
  end
  let!(:genre_class) do

    Class.new(RakutenWebService::BaseGenre) do
      endpoint "https://api.example.com/dummy_genre"
      self.resource_name = 'dummy_genre'
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

  after do
    RakutenWebService::BaseGenre.instance_variable_set(:@repository, {})
  end

  describe ".genre_id_key" do
    it { expect(genre_class.genre_id_key).to be_eql(:dummy_genre_id) }
  end

  describe ".root_id" do
    it { expect(genre_class.root_id).to be_eql(0) }
  end

  describe ".new" do
    context "When given string or integer" do
      specify "should call search" do
        genre_class.new(genre_id)

        expect(expected_request).to have_been_made.once
      end

      specify "should call once if the same instance was initialized twice" do
        2.times { genre_class.new(genre_id) }

        expect(expected_request).to have_been_made.once
      end
    end

    context "When a Hash is given" do
      subject { genre_class.new(dummyGenreId: 10, dummyGenreName: "NewGenre") }

      specify "API request should not been called" do
        expect(expected_request).to_not have_been_made
      end
      it "shoud respond apropriate attributes" do
        expect(subject.id).to be_eql(10)
        expect(subject.name).to be_eql("NewGenre")
      end
    end
  end

  describe ".[]" do
    specify "should call search only once as intializing twice" do
      2.times { genre_class[genre_id] }

      expect(expected_request).to have_been_made.once
    end
  end

  describe "#children" do
    subject { genre_class.new(genre_id).children }

    it { is_expected.to_not be_empty }

    context "children's children" do
      before do
        subject
      end

      it "should search again" do
        expect(genre_class).to receive(:search).
          with(dummy_genre_id: 2).
          and_return([
            double(:genre, children: [])
          ])

        expect(subject.first.children).to_not be_nil
        expect(subject.first.children).to be_empty
      end
    end
  end

  describe "#parents" do
    subject { genre_class.new(genre_id).children }

    it { is_expected.to_not be_empty }

    context "children's parents" do
      before do
        subject
      end

      it "should search again" do
        expect(genre_class).to receive(:search).
          with(dummy_genre_id: 2).
          and_return([
            double(:genre, parents: [])
          ])

        expect(subject.first.parents).to be_empty
        expect(subject.first.parents).to_not be_nil
      end
    end
  end

  describe "#brothers" do
    subject { genre_class.new(genre_id).children }

    it { is_expected.to_not be_empty }

    context "children's brothers" do
      before do
        subject
      end

      it "should search again" do
        expect(genre_class).to receive(:search).
          with(dummy_genre_id: 2).
          and_return([
            double(:genre, brothers: [])
          ])

        expect(subject.first.brothers).to be_empty
        expect(subject.first.brothers).to_not be_nil
      end
    end
  end
end