require 'spec_helper'
require 'rakuten_web_service/travel/open_struct'

describe RakutenWebService::Travel::OpenStruct do
  let(:object) { RakutenWebService::Travel::OpenStruct.new(params) }

  context 'Given simple hash with pairs of key-value' do
    let(:params) do
      { foo: 'bar', 'hoge' => 1, 'maxSize' => 100 }
    end

    specify 'should have interfaces with the name of a given hash keys' do
      expect(object).to respond_to(:foo)
      expect(object.foo).to eq(params[:foo])
      expect(object).to respond_to(:hoge)
      expect(object.hoge).to eq(params['hoge'])
    end
    specify 'should generate snakecase-method name' do
      expect(object).to respond_to('maxSize')
      expect(object).to respond_to('max_size')
    end
  end

  context 'Given a hash including a hash' do
    let(:params) do
      {
        name: 'Taro',
        address: { country: :jp, city: :tokyo }
      }
    end

    specify 'the inside hash should be converted to OpenStruct' do
      expect(object.address.country).to eql(:jp)
      expect(object.address.city).to eql(:tokyo)
    end
  end

  context 'Giving an array of hash' do
    let(:params) do
      {
        array: [
          { foo: 'bar' },
          { hoge: 'fuga' }
        ]
      }
    end

    specify 'the array should be converted to OpenStruct' do
      expect(object.array[0].foo).to eql('bar')
      expect(object.array[1].hoge).to eql('fuga')
    end
  end
end
