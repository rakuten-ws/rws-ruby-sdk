require 'spec_helper'

describe RakutenWebService::Response do

  describe "Pagenate helpers" do
    let(:resource_class) { double(:resource_class) }

    subject { RakutenWebService::Response.new(resource_class, json) }

    context "When page is less than pageCount" do
      let(:json) do
        {
          'page' => 1, 'pageCount' => 2
        }
      end

      it { is_expected.to have_next_page }
      it { is_expected.to_not be_last_page }
      it { is_expected.to_not have_previous_page }
      it { is_expected.to be_first_page }
    end
    context "When page is equal to pageCount" do
      let(:json) do
        {
          'page' => 2, 'pageCount' => 2
        }
      end

      it { is_expected.to_not have_next_page }
      it { is_expected.to be_last_page }
      it { is_expected.to have_previous_page }
      it { is_expected.to_not be_first_page }
    end
    context "When current page is in pages" do
      let(:json) do
        {
          'page' => 2, 'pageCount' => 3
        }
      end

      it { is_expected.to have_next_page }
      it { is_expected.to_not be_last_page }
      it { is_expected.to have_previous_page }
      it { is_expected.to_not be_last_page }
    end
  end
end