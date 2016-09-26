require 'spec_helper'

describe RakutenWebService::GenreInformation do
  describe '#initialize' do
    let(:expected_params) do
      {
        "parent" => [],
        "current" => [],
        "children" => [
          {
            "child" => {
              "genreId" => "564500",
              "genereName" => "光回線・モバイル通信",
              "itemCount" => "5",
              "genreLevel" => "1"
            }
          }
        ]
      }
    end

    subject { RakutenWebService::GenreInformation.new(expected_params) }

    it { is_expected.to be_a(RakutenWebService::GenreInformation) }
  end
end
