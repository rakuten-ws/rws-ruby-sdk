require 'spec_helper'
require 'rakuten_web_service/configuration'

describe RakutenWebService::Configuration do
  describe '#initialize' do
    context "environment variable RWS_APPLICATION_ID, RWS_AFFILIATE_ID and RWS_ACCESS_KEY are defined" do
      before do
        ENV['RWS_APPLICATION_ID'] = 'env_application_id'
        ENV['RWS_AFFILIATE_ID'] = 'env_affiliate_id'
        ENV['RWS_ACCESS_KEY'] = 'env_access_key'
      end

      after do
        ENV.delete 'RWS_APPLICATION_ID'
        ENV.delete 'RWS_AFFILIATE_ID'
        ENV.delete 'RWS_ACCESS_KEY'
      end

      subject { RakutenWebService::Configuration.new }

      specify "the application id, affiliate id and access key are set by the environment variables" do
        expect(subject.application_id).to eq 'env_application_id'
        expect(subject.affiliate_id).to eq 'env_affiliate_id'
        expect(subject.access_key).to eq 'env_access_key'
      end
    end
  end

  describe '#debug_mode?' do
    let(:configuration) { RakutenWebService.configuration }

    before do
      configuration.debug = true
    end

    it 'should return true' do
      expect(configuration).to be_debug_mode
    end

    context 'When RWS_SDK_DEBUG is defined' do
      before do
        ENV['RWS_SDK_DEBUG'] = 'true'
        configuration.debug = false
      end

      after do
        ENV.delete('RWS_SDK_DEBUG')
      end

      it 'should return true' do
        expect(configuration).to be_debug_mode
        expect(configuration.debug).to be_falsey
      end
    end
  end

  describe '#access_key_transport=' do
    let(:config) { RakutenWebService::Configuration.new }

    %i[access_key_header query].each do |valid_value|
      it "accepts :#{valid_value}" do
        config.access_key_transport = valid_value
        expect(config.access_key_transport).to eq valid_value
      end
    end

    it 'raises ArgumentError for invalid value' do
      expect { config.access_key_transport = :invalid }.to raise_error(ArgumentError)
    end
  end

  describe "#default_parameters" do
    before do
      RakutenWebService.configure do |c|
        c.application_id = application_id
        c.access_key = access_key
      end
    end

    let(:access_key) { 'access_key' }

    context "When application id and access key are given" do
      let(:application_id) { 'app_id' }

      subject { RakutenWebService.configuration.default_parameters }

      it "has application_id key and its value is a given value" do
        expect(subject[:application_id]).to eq 'app_id'
      end

      it "does not include access_key in parameters" do
        expect(subject).not_to have_key(:access_key)
      end

      context "when access_key_transport is :query" do
        around do |example|
          original = RakutenWebService.configuration.access_key_transport
          RakutenWebService.configuration.access_key_transport = :query
          example.run
          RakutenWebService.configuration.access_key_transport = original
        end

        it "includes access_key in parameters" do
          expect(subject[:access_key]).to eq 'access_key'
        end
      end

    end
    context "When application id is not given" do
      let(:application_id) { nil }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID and access key are not defined")
      end
    end
    context "When application id is an empty string" do
      let(:application_id) { '' }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID and access key are not defined")
      end
    end
    context "When access key is not given" do
      let(:application_id) { 'app_id' }
      let(:access_key) { nil }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID and access key are not defined")
      end
    end
    context "When access key is an empty string" do
      let(:application_id) { 'app_id' }
      let(:access_key) { '' }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID and access key are not defined")
      end
    end
  end
end
