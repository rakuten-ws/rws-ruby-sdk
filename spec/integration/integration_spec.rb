require 'spec_helper'

describe 'Call all APIs', type: 'integration' do
  describe RakutenWebService::Ichiba do
    it { RakutenWebService::Ichiba::Item.search(keyword: 'Ruby').first }
  end
end