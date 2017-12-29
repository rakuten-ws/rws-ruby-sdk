require 'spec_helper'

describe RakutenWebService::Resource do
  let(:resource_class) do
    Class.new(RakutenWebService::Resource) do
      set_resource_name 'Dummy'

      attribute :name, :dummySampleAttribute
    end
  end

  describe '#attributes' do
    let(:params) do
      {
        name: 'hoge',
        dummySampleAttribute: 'fuga'
      }
    end

    subject { resource_class.new(params).attributes }

    it { is_expected.to match_array(params.keys.map(&:to_s)) }
  end
end