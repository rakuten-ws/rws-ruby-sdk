# encoding: utf-8

require 'spec_helper'
require 'rakuten_web_service/ichiba/item'

describe RakutenWebService::Ichiba::Item do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120805' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:developer_id) { 'dummy_developer_id' }
  let(:expected_query) do
    {
      :affiliate_id => affiliate_id,
      :developer_id => developer_id,
      :keyword => 'Ruby'
    }
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).
      to_return(:body => fixture('ichiba/item_search_with_keyword_Ruby.json'))

    @items = RakutenWebService::Ichiba::Item.search(:affiliate_id => affiliate_id,
      :developer_id => developer_id,
      :keyword => 'Ruby')
  end

  specify 'endpoint should be called once' do
    expect(@expected_request).to have_been_made.once
  end

  specify 'should returns Item objects' do
    expect(@items.size).to eq(30)
  end
end
