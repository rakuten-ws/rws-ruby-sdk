require 'spec_helper'
require 'rakuten_web_service/ichiba/tag_group'

describe RakutenWebService::Ichiba::TagGroup do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/IchibaTag/Search/20140222' }
  let(:affiliate_id) { 'affiliate_id' }
  let(:application_id) { 'application_id' }
  let(:expected_query) do
    {
      affiliateId: affiliate_id,
      applicationId: application_id,
      formatVersion: '2',
      tagId: '1000317'
    }
  end

  before do
    response = JSON.parse(fixture('ichiba/tag_search.json'))
    @expected_request = stub_request(:get, endpoint).
      with(query: expected_query).to_return(body: response.to_json)

    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    let(:expected_json) do
      response = JSON.parse(fixture('ichiba/tag_search.json'))
      response['tagGroups'][0]
    end

    before do
      @tag_group = RakutenWebService::Ichiba::TagGroup.search({tagId: '1000317'}).first
    end

    subject { @tag_group }

    specify 'should call the endpoint once' do
      expect(@expected_request).to have_been_made.once
    end

    specify 'should be access by key' do
      expect(subject['tagGroupId']).to eq(expected_json['tagGroupId'])
      expect(subject['tag_group_id']).to eq(expected_json['tagGroupId'])
    end
  end

  describe '#tags' do
    let(:response) { JSON.parse(fixture('ichiba/tag_search.json')) }
    let(:expected_tag) { response['tagGroups'][0]['tags'][0] }

    before do
      @tag_group = RakutenWebService::Ichiba::TagGroup.search(tagId: '1000317').first
    end

    subject { @tag_group.tags }

    specify 'responds Tags object' do
      subject.map do |tag|
        expect(tag.id).to eq(expected_tag['tagId'])
        expect(tag.name).to eq(expected_tag['tagName'])
        expect(tag['parentTagId']).to eq(expected_tag['parentTagId'])
      end
    end
  end
end
