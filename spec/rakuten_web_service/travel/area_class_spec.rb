require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Travel::AreaClass do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: 2
    }
  end
  let(:response) { JSON.parse(fixture('travel/area_class.json')) }
  let!(:expected_request) do
    stub_request(:get, endpoint)
      .with(query: expected_query).to_return(body: response.to_json)
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      @area_class = RakutenWebService::Travel::AreaClass.search.first
    end

    specify 'respond largeClass' do
      expect(@area_class['largeClassCode']).to eq('japan')
      expect(@area_class['largeClassName']).to eq('日本')
    end
    specify '#children method responds all middle claasses under a given large class' do
      expect(@area_class.children).to_not be_empty
      expect(@area_class.children).to be_all do |entity|
        entity.is_a?(RWS::Travel::AreaClass::MiddleClass)
      end
    end
    specify '["middle_classes"] responds all middle claasses under a given large class' do
      expect(@area_class["middleClasses"]).to_not be_empty
      expect(@area_class["middleClasses"]).to be_all do |entity|
        entity.is_a?(RWS::Travel::AreaClass::MiddleClass)
      end
    end
  end

  describe '#parent' do
    before do
      @area_class = RakutenWebService::Travel::AreaClass.search.first
    end

    specify 'parent is null' do
      expect(@area_class.parent).to be_nil
    end
    specify 'the self is the parent of children' do
      expect(@area_class.children).to be_all do |child|
        child.parent == @area_class
      end
    end
  end

  describe '#to_query' do
    before do
      @area_class = RakutenWebService::Travel::AreaClass.search.first
    end

    specify 'As for LargeClass object, returns only its class code.' do
      expect(@area_class.to_query).to eq({ 'largeClassCode' => 'japan' })
    end
    specify 'As for MiddleClass object, returns only its class code.' do
      @area_class.children.each do |child|
        expect(child.to_query).to eq({ 'largeClassCode' => 'japan', 'middleClassCode' => child.middle_class_code })
      end
    end
  end

  describe '.[] method' do
    specify 'accepts a area code as argument and respond an class object with the given class code' do
      expect(RakutenWebService::Travel::AreaClass::LargeClass['japan']).to be_a(RakutenWebService::Travel::AreaClass::LargeClass)
      expect(RakutenWebService::Travel::AreaClass::LargeClass['japan'].large_class_code).to eq('japan')
    end
    specify 'AreaClass.[] supports' do
      expect(RakutenWebService::Travel::AreaClass['japan']).to be_a(RakutenWebService::Travel::AreaClass::LargeClass)
      expect(RakutenWebService::Travel::AreaClass['japan'].class_code).to eq('japan')

      expect(RakutenWebService::Travel::AreaClass['hokkaido']).to be_a(RakutenWebService::Travel::AreaClass::MiddleClass)
      expect(RakutenWebService::Travel::AreaClass['hokkaido'].class_code).to eq('hokkaido')
    end
  end

  describe '#search' do
    let(:area_class) { RakutenWebService::Travel::AreaClass['sapporo'] }

    specify 'pass area class codes to the simple hotel API' do
      expect(RakutenWebService::Travel::Hotel).to receive(:search).with({
        'largeClassCode' => 'japan', 'middleClassCode' => 'hokkaido', 'smallClassCode' => 'sapporo'
      })

      area_class.search()
    end

    context 'Giving params' do
      specify 'pass area class codes with the given params to the simple hotel API' do
        expect(RakutenWebService::Travel::Hotel).to receive(:search).with({
          'largeClassCode' => 'japan', 'middleClassCode' => 'hokkaido', 'smallClassCode' => 'sapporo',
          'responseType' => 'large'
        })

        area_class.search('responseType' => 'large')
      end
    end
  end
end
