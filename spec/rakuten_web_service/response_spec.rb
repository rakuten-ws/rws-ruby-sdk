require 'spec_helper'

describe RakutenWebService::Response do

  describe "#has_next_page?" do
    let(:resource_class) { double(:resource_class) }
    let(:json) do
      {
        'page' => 1,
        'pageCount' => 2
      }
    end

    subject { RakutenWebService::Response.new(resource_class, json) }

    it { is_expected.to have_next_page }
  end
end