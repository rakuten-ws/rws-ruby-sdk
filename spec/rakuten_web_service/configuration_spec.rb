require 'spec_helper'
require 'rakuten_web_service/configuration'

describe RakutenWebService::Configuration do
  describe '#initialize' do
    context "environment variable RWS_APPLICATION_ID and RWS_AFFILIATE_ID are defined" do
      before do
        ENV['RWS_APPLICATION_ID'] = 'env_application_id'
        ENV['RWS_AFFILIATE_ID'] = 'env_affiliate_id'
      end

      after do
        ENV.delete 'RWS_APPLICATION_ID'
        ENV.delete 'RWS_AFFILIATE_ID'
      end

      subject { RakutenWebService::Configuration.new }

      specify "the application id is set by the environment variable" do
        expect(subject.application_id).to eq 'env_application_id'
        expect(subject.affiliate_id).to eq 'env_affiliate_id'
      end
    end
  end

  describe '.configure' do
    context 'given block has one arity' do
      before do
        RakutenWebService.configure do |c|
          c.affiliate_id = 'dummy_affiliate_id'
          c.application_id = 'dummy_application_id'
        end
      end

      subject { RakutenWebService.configuration }

      describe '#affiliate_id' do
        subject { super().affiliate_id }
        it { is_expected.to eq('dummy_affiliate_id') }
      end

      describe '#application_id' do
        subject { super().application_id }
        it { is_expected.to eq('dummy_application_id') }
      end
    end

    context 'given block has more or less one arity' do
      specify 'raise ArgumentError' do
        expect do
          RakutenWebService.configure do
          end
        end.to raise_error(ArgumentError)

        expect do
          RakutenWebService.configure do |c, _|
            c.affiliate_id = 'dummy_affiliate_id'
            c.application_id = 'dummy_application_id'
          end
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe '.configuration' do
    context 'When calling with a block' do
      specify 'should show warning message' do
        $stderr = StringIO.new
        RakutenWebService.configuration do |c|
          c.application_id = 'dummy_affiliate_id'
        end
        expect($stderr.string).to match(/Warning: /)
        $stderr = STDERR
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

  describe "#default_parameters" do
    before do
      RakutenWebService.configure do |c|
        c.application_id = application_id
      end
    end

    context "When application id is given" do
      let(:application_id) { 'app_id' }

      subject { RakutenWebService.configuration.default_parameters }

      it "has application_id key and its value is a given value" do
        expect(subject[:application_id]).to eq 'app_id'
      end
    end
    context "When application id is not given" do
      let(:application_id) { nil }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID is not defined")
      end
    end
    context "When application id is an empty string" do
      let(:application_id) { '' }

      it "raises an error" do
        expect {
          RakutenWebService.configuration.default_parameters
        }.to raise_error(RuntimeError, "Application ID is not defined")
      end
    end
  end
end
