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
end
