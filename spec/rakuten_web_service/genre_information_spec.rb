require 'spec_helper'

describe RakutenWebService::GenreInformation do
  describe '#initialize' do
    subject { RakutenWebService::GenreInformation.new(expected_params, RWS::Ichiba::Genre) }

    context "When given params only has children genres" do
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
        it "has its item count" do
          expect(subject.item_count).to eq('5')
        end
      end
    end
    context "When given params has current genre" do
      let(:expected_params) do
        {
          "parent" => [],
          "current" => [
            {
              "genreId" => "564500",
              "genreName" => "スマートフォン・タブレット",
              "itemCount" => "313045",
              "genreLevel" => "1"
            }
          ],
          "children" => [
          ]
        }
      end
specify "its parent should be nil" do expect(subject.parent).to be_nil
      end
      specify "its current should be a Genre object" do
        expect(subject.current).to be_a(RWS::Ichiba::Genre)
      end
      specify "its children should be empty" do
        expect(subject.children).to be_empty
      end
    end
    context "When given params has parent genre" do
      let(:expected_params) do
        {
          "parent" => [
            {
              "genreId" => "564500",
              "genreName" => "スマートフォン・タブレット",
              "itemCount" => "313045",
              "genreLevel" => "1"
            }
          ],
          "current" => [
            {
              "genreId" => "560029",
              "genreName" => "タブレットPC本体",
              "itemCount" => "0",
              "genreLevel" => "2"
            }
          ],
          "children" => [
          ]
        }
      end

      specify "its parent should be a Genre object" do
        expect(subject.parent).to be_a(RWS::Ichiba::Genre)
      end
      specify "its current should be a Gere object" do
        expect(subject.current).to be_a(RWS::Ichiba::Genre)
      end
      specify "its children should be empty" do
        expect(subject.children).to be_empty
      end

      context "After re-initialize Genre with same genre id" do
        let(:genre) { RWS::Ichiba::Genre.new('560029') }

        before do
          subject.current
        end

        it "doesn't have item_count value" do
          expect(genre.item_count).to be_nil
        end
      end
    end
  end
end
