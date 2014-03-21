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
            to_return(:body => {:current => 
                                  { :genreId => new_genre_id,
                                    :genreName => 'DummyGenre',
                                    :genreLevel => 3 }
                               }.to_json)

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

  describe '#children' do
    let(:root_genre) { RakutenWebService::Ichiba::Genre.new(genre_id) }

    subject { root_genre.children }

    specify 'children respond genres under the specified genre' do
      expect(root_genre.children.size).to eq(expected_json['children'].size)
    end

    context 'when children of the genre have not been fetched' do
      let(:target_genre) { expected_json['children'].first['child'] }

      before do
        @additional_request = stub_request(:get, endpoint).
          with(:query => {
               :affiliateId => affiliate_id,
               :applicationId => application_id,
               :genreId => target_genre['genreId']
          }).to_return(:body => {
            :current => target_genre,
            :children => []
          }.to_json)
      end

      subject { root_genre.children.first }

      specify 'should call ' do
        expect(subject.children.size).to eq(0)
        expect(@additional_request).to have_been_made
      end

    end
  end

  describe '#ranking' do
    let(:genre) { RakutenWebService::Ichiba::Genre.new(genre_id) }

    before do
      stub_request(:get, endpoint).with(:query => expected_query).
        to_return(:body => fixture('ichiba/genre_search.json'))
    end

    specify "should call RankingItem's search with genre_id option" do
      RakutenWebService::Ichiba::RankingItem.should_receive(:search).with(:genre_id => genre_id)
      expect { genre.ranking }.to_not raise_error
    end
  end

  describe '#products' do
    let(:genre) { RakutenWebService::Ichiba::Genre.new(genre_id) }

    before do
      stub_request(:get, endpoint).with(:query => expected_query).
        to_return(:body => fixture('ichiba/genre_search.json'))
    end

    specify "should call Product search with genre_id option" do
      RakutenWebService::Ichiba::Product.should_receive(:search).with(:genre_id => genre_id)
      expect { genre.products }.to_not raise_error
    end
  end
end
