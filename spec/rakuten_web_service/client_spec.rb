require 'spec_helper'
require 'rakuten_web_service/client'

describe RakutenWebService::Client do
  let(:endpoint) { 'http://api.example.com/resources' }
  let(:client) { RakutenWebService::Client.new(endpoint) }
  let(:application_id) { 'default_application_id' }
  let(:affiliate_id) { 'default_affiliate_id' }
  let(:expected_query) do
    { :affiliateId => affiliate_id, :applicationId => application_id }
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(:query => expected_query).
      to_return(:body => '{"status":"ok"}')

    RakutenWebService.configuration do |c|
      c.affiliate_id = 'default_affiliate_id'
      c.application_id = 'default_application_id'
    end
  end

  context 'call get without any parameters' do
    before do
      client.get({})
    end

    specify 'call endpoint with default parameters' do
      expect(@expected_request).to have_been_made.once
    end
  end

  context 'call get with parameters' do
    let(:affiliate_id) { 'latest_affiliate_id' }
    let(:application_id) { 'latest_application_id' }

    before do
      client.get(:affiliate_id => affiliate_id,
                 :application_id => application_id)
    end

    specify 'call endpoint with given parameters' do
      expect(@expected_request).to have_been_made.once
    end
  end

end
