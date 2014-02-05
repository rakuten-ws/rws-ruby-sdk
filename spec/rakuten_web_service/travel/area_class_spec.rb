require 'spec_helper'
require 'rakuten_web_service'

describe RakutenWebService::Travel::AreaClass do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
      :affiliateId => affiliate_id,
      :applicationId => application_id
    }
  end
  let(:response) { JSON.parse(fixture('travel/area_class.json')) }
  let!(:expected_request) do
    stub_request(:get, endpoint).
     with(:query => expected_query).to_return(:body => response.to_json)
  end

  before do
    RakutenWebService.configuration do |c|
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
end
