require 'rakuten_web_service'

describe RakutenWebService::Ichiba, integration: true do
  before :all do
    RakutenWebService.configuration do |c|
      c.application_id = ENV['RWS_APPLICATION_ID']
    end
  end

  describe RakutenWebService::Ichiba::Item do
    let(:params) { { keyword: 'Rakuten' } }
    let(:items) { RakutenWebService::Ichiba::Item.search(params) }

    specify 'should search without error' do
      expect { items.first }.to_not raise_error
    end
  end
end
