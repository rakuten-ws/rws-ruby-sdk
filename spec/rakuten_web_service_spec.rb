require 'spec_helper'

describe RakutenWebService do
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
    context 'call without block' do
      specify 'raise ArgumentError' do
        expect { RakutenWebService.configure }.to raise_error(ArgumentError)
      end
    end
  end
end
