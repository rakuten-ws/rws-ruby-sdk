require 'spec_helper'
require 'rakuten_web_service/configuration'

describe RakutenWebService::Configuration do
  describe '.configuration' do
    context 'given block has one arity' do
      before do
        RakutenWebService.configuration do |c|
          c.affiliate_id = 'dummy_affiliate_id'
          c.application_id = 'dummy_application_id'
        end
      end

      subject { RakutenWebService.configuration }

      its(:affiliate_id) { should eq('dummy_affiliate_id') }
      its(:application_id) { should eq('dummy_application_id') }
    end

    context 'given block has more or less one arity' do
      specify 'raise ArgumentError' do
        expect do
          RakutenWebService.configuration do
          end
        end.to raise_error(ArgumentError)

        expect do
          RakutenWebService.configuration do |c, _|
            c.affiliate_id = 'dummy_affiliate_id'
            c.application_id = 'dummy_application_id'
          end
        end.to raise_error(ArgumentError)
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
        expect(configuration.debug).to be_false
      end
    end
  end
end
