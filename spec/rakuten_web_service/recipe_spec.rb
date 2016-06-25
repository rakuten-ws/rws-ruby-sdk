require 'spec_helper'

describe RakutenWebService::Recipe do
  describe '.search' do
    it 'should not be called' do
      expect { RWS::Recipe.search(category_id: '10') }.to raise_error
    end
  end

  describe '.ranking' do
    let(:category_id) { '10' }

    it 'should call search with category id' do
      expect(RWS::Recipe).to receive(:search).with(category_id: category_id)

      RakutenWebService::Recipe.ranking(category_id)
    end
  end
end
