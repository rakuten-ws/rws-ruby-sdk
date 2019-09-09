require 'spec_helper'

describe RakutenWebService::Ichiba::Tag do
  let(:params) do
    { 'tagId' => 100,
      'tagName' => 'SS',
      'parentTagId' => 1 }
  end
  let(:shop) { RakutenWebService::Ichiba::Tag.new(params) }

  describe '.new' do
    specify 'returned object should have methods to fetch values' do
      expect(shop.id).to eq(100)
      expect(shop.name).to eq('SS')
      expect(shop['parentTagId']).to eq(1)
    end
  end
end
