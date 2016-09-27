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
              "genreName" => "光回線・モバイル通信",
              "itemCount" => "5",
              "genreLevel" => "1"
            }
          }
        ]
      }
    end

    subject { RakutenWebService::GenreInformation.new(expected_params) }

    it { is_expected.to be_a(RakutenWebService::GenreInformation) }
    specify "its parent should be nil" do
      expect(subject.parent).to be_nil
    end
    specify "its current should be nil" do
      expect(subject.current).to be_nil
    end
    specify "its children should returns a array of Genre" do
      expect(subject.children).to_not be_empty
    end

    describe "each child" do
      subject { super().children.first }

      it "has genre id" do
        expect(subject.id).to eq('564500')
      end
      it "has genre name" do
        expect(subject.name).to eq('光回線・モバイル通信')
      end
      it "has its genre level" do
        expect(subject.level).to eq('1')
      end
    end
  end
end
