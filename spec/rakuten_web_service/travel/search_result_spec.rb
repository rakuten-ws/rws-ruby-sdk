require 'spec_helper'

describe RakutenWebService::Travel::SearchResult do
  let(:resource_class) do
    Class.new(RakutenWebService::Resource) do
      endpoint 'https://api.example.com/SearchDummyResource'
    end
  end
  let(:search_result) do
    RakutenWebService::Travel::SearchResult.new({}, resource_class)
  end

  describe '#next_page?' do
    let(:response) do
      double().tap do |d|
        allow(d).to receive('[]').with('pagingInfo').and_return(pagingInfo)
      end
    end

    before do
      allow(search_result).to receive(:response).and_return(response)
    end

    context 'when current page does not reach at the last page'  do
      let(:pagingInfo) do
        { 'page' => 1, 'pageCount' => 10 }
      end

      it 'should have next page' do
        expect(search_result).to be_next_page
      end
    end
    context 'when current page reaches at the last page' do
      let(:pagingInfo) do
        { 'page' => 5, 'pageCount' => 5 }
      end

      it 'should not have next page' do
        expect(search_result).to_not be_next_page
      end
    end
  end

  describe '#next_page' do
    let(:response) do
      double().tap do |d|
        allow(d).to receive('[]').with('pagingInfo').and_return(pagingInfo)
      end
    end

    before do
      allow(search_result).to receive(:response).and_return(response)
    end

    let(:pagingInfo) do
      { 'page' => 2, 'pageCount' => 3 }
    end

    it 'shold call search to fetch next page results.' do
      expect(search_result).to receive(:search).with({'page' => 3})

      search_result.next_page
    end
  end

  describe '#search' do
    it 'should return trave\'s search result' do
      expect(search_result.search({})).to be_a(RakutenWebService::Travel::SearchResult)
    end
  end
end
