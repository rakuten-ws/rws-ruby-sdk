require 'spec_helper'

describe RakutenWebService::Ichiba::Item do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      keyword: 'Ruby'
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
      response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      response['pageCount'] = 2
      @second_request = stub_request(:get, endpoint).
        with(query: expected_query.merge(page: 2)).
        to_return(body: response.to_json)
    end

    context 'just call the search method' do
      before do
        @items = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby')
      end

      specify 'endpoint should not be called' do
        expect(@expected_request).to_not have_been_made
      end

      describe 'a respond object' do
        let(:expected_json) do
          response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
          response['Items'][0]
        end

        subject { @items.first }

        it { is_expected.to be_a RakutenWebService::Ichiba::Item }
        specify 'shoud be access by key' do
          expect(subject['itemName']).to eq(expected_json['itemName'])
          expect(subject['item_name']).to eq(expected_json['itemName'])
        end

        describe '#name' do
          subject { super().name }
          it { is_expected.to eq(expected_json['itemName']) }
        end
        specify 'should have xxx? method if the object has xxx_flag' do
          expect(subject.tax?).to eq(expected_json['taxFlag'] == 1)
        end
      end

      context 'after that, call each' do
        before do
          @items.each { |i| i }
        end

        specify 'endpoint should be called' do
          expect(@expected_request).to have_been_made.once
          expect(@second_request).to_not have_been_made
        end
      end

      context 'chain calling' do
        before do
          @items2 = @items.search(keyword: 'Go')
        end

        specify "2 search resutls should be independent" do
          expect(@items.params[:keyword]).to eq('Ruby')
          expect(@items2.params[:keyword]).to eq('Go')
        end
      end

      describe '#all' do
        before do
          @items.all
        end

        specify 'endpoint should not be called' do
          expect(@expected_request).to_not have_been_made.once
          expect(@second_request).to_not have_been_made.once
        end

        context 'call an enumerable method like each' do
          before do
            @items.all.each { |i| i.to_s }
          end

          specify 'endpoint should be called' do
            expect(@expected_request).to have_been_made.once
            expect(@second_request).to have_been_made.once
          end
        end
      end

      context 'When TooManyRequest error raised' do
        let(:client) do
          c = double('client')
          allow(c).to receive(:get).and_raise(RWS::TooManyRequests)
          c
        end

        before do
          @items.instance_variable_set('@client', client)
        end

        specify 'retries automatically after sleeping 1 sec' do
          expect(@items).to receive(:sleep).with(1).exactly(5).times.and_return(*([nil] * 5))
          expect { @items.first.name }.to raise_error(RakutenWebService::TooManyRequests)
        end
      end
    end
  end

  describe '.all' do
    before do
      response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      response['pageCount'] = 2
      @second_request = stub_request(:get, endpoint).
        with(query: expected_query.merge(page: 2)).
        to_return(body: response.to_json)
    end

    context 'When givne a block' do
      specify '' do
        expect { |b| RWS::Ichiba::Item.all({keyword: 'Ruby'}, &b) }.to yield_control.exactly(60).times

        expect { |b| RWS::Ichiba::Item.all({keyword: 'Ruby'}, &b) }.to yield_successive_args(*([RakutenWebService::Ichiba::Item] * 60))
      end
    end
  end

  describe '.ranking' do
    before do
      expect(RakutenWebService::Ichiba::RankingItem).to receive(:search).with({})
    end

    specify "call RakutenWebService::Ichiba::RankingItem's search" do
      RakutenWebService::Ichiba::Item.ranking
    end
  end

  describe ".genre_class" do
    subject { RakutenWebService::Ichiba::Item }

    it "returns RakutenWebService::Ichiba::Genre" do
      expect(subject.genre_class).to eq(RakutenWebService::Ichiba::Genre)
    end
  end

  describe '#genre' do
    let(:response) { JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json')) }

    before do
      stub_request(:get, endpoint).with(query: expected_query).
        to_return(body: response.to_json)

      expected_item = response['Items'][0]
      expect(RakutenWebService::Ichiba::Genre).to receive('new').with(expected_item['genreId'])
    end

    subject { RakutenWebService::Ichiba::Item.search(keyword: 'Ruby').first.genre }

    specify 'respond Genre object' do
      expect { subject }.to_not raise_error
    end
  end

  describe '#shop' do
    let(:response) { JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json')) }
    let(:expected_item) { response['Items'][0] }

    before do
      stub_request(:get, endpoint).with(query: expected_query).
        to_return(body: response.to_json)
    end

    subject do
      RakutenWebService::Ichiba::Item.search(keyword: 'Ruby').first.shop
    end

    specify 'responds Shop object' do
      expect(subject.name).to eq(expected_item['shopName'])
      expect(subject.code).to eq(expected_item['shopCode'])
      expect(subject.url).to eq(expected_item['shopUrl'])
      expect(subject.affiliate_url).to eq(expected_item['shopAffiliateUrl'])
    end
  end

  describe '#order' do
    specify 'convert sort parameter' do
      query = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby').order(affiliate_rate: :desc)

      expect(query.params[:sort]).to eq('-affiliateRate')
    end

    specify 'reproduces new SearchResult object' do
      first_query = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby')
      second_query = first_query.order(affiliate_rate: :desc)

      expect(first_query.params[:sort]).to be_nil
      expect(second_query.params[:sort]).to eq('-affiliateRate')
    end
  end

  describe '#genre_information' do
    before do
      response = JSON.parse(fixture('ichiba/item_search_with_keyword_Ruby.json'))
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query).to_return(body: response.to_json)
    end

    subject { RWS::Ichiba::Item.search(keyword: 'Ruby').genre_information }

    it "should be a GenreInformation" do
      expect(subject).to be_a(RWS::GenreInformation)
    end
  end
end
