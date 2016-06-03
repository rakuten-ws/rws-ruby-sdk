require 'rakuten_web_service'

describe RakutenWebService::Ichiba, integration: true do
  describe RakutenWebService::Ichiba::Item do
    let(:params) { { keyword: 'Rakuten' } }
    let(:items) { RakutenWebService::Ichiba::Item.search(params) }

    describe '#first' do
      specify 'should search without error' do
        expect { items.first }.to_not raise_error
      end
    end
    describe '#all' do
      specify 'should respond all resources without error' do
        expect { items.all }.to_not raise_error
      end
      specify 'each resource should respond attributes' do
        expect(items.all).to be_all(&:name)
      end
    end
  end
end
