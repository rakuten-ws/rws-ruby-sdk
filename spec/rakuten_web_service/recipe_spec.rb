require 'spec_helper'

describe RakutenWebService::Recipe do
  describe '.search' do
    it 'should not be called' do
      expect { RWS::Recipe.search(category_id: '10') }.to raise_error
    end
  end
end
