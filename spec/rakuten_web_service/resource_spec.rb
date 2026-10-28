require 'spec_helper'

describe RakutenWebService::Resource do
  let(:resource_class) do
    Class.new(RakutenWebService::Resource) do
      self.resource_name = 'Dummy'

      attribute :name, :dummySampleAttribute
    end
  end

  describe '.subclasses' do
    before do
      resource_class
    end

    subject { RakutenWebService::Resource.subclasses }

    specify 'returns all sub classes of Resource' do
      expect(subject).to include(resource_class)
    end

    context 'When some resources are inherited from other resource' do
      let(:other_resource_class) do
        Class.new(resource_class) do
          self.resource_name = 'NestedResource'

          attribute :name, :someOtherAttribute
        end
      end

      before do
        other_resource_class
      end

      specify 'includes nested resources' do
        expect(subject).to include(resource_class, other_resource_class)
      end
    end
  end

  describe '.attribute_methods' do
    let(:resource_class) do
      Class.new(RakutenWebService::Resource) do
        self.resource_name = 'dummy'

        attribute :dummyName, :sampleAttribute, :postageFlag
      end
    end

    subject { resource_class.attribute_methods }

    it { is_expected.to eq(%w[name sample_attribute postage_flag postage?]) }

    context 'When the resource is inherited from other resource' do
      let(:other_resource_class) do
        Class.new(resource_class) do
          self.resource_name = 'nested'

          attribute :rank
        end
      end

      subject { other_resource_class.attribute_methods }

      specify 'does not include the methods defined in the superclass' do
        expect(subject).to eq(%w[rank])
      end
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