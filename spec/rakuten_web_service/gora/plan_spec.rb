require 'spec_helper'

describe RakutenWebService::Gora::Plan do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Gora/GoraPlanSearch/20170623' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
        affiliateId: affiliate_id,
        applicationId: application_id,
        formatVersion: '2',
        areaCode: '12,14',
        playDate: '2016-04-24',
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '.search' do
    before do
      response = JSON.parse(fixture('gora/plan_search_with_area_code.json'))
      @expected_request = stub_request(:get, endpoint).
          with(query: expected_query).to_return(body: response.to_json)
    end

    specify 'endpoint should not be called' do
      expect(@expected_request).to_not have_been_made
    end

    context 'just call the search method' do
      before do
        @plans = RakutenWebService::Gora::Plan.search(areaCode: expected_query[:areaCode], playDate: expected_query[:playDate])
      end

      specify 'endpoint should not be called' do
        expect(@expected_request).to_not have_been_made
      end

      describe 'a respond object' do
        let(:expected_json) do
          response = JSON.parse(fixture('gora/plan_search_with_area_code.json'))
          response['Items'][0]
        end

        subject { @plans.first }

        it { is_expected.to be_a RakutenWebService::Gora::Plan }
        specify 'should be accessed by key' do
          expect(subject['golfCourseId']).to eq(expected_json['golfCourseId'])
          expect(subject['golf_course_id']).to eq(expected_json['golfCourseId'])
        end

        describe '#golf_course_id' do
          subject { super().golf_course_id }
          it { is_expected.to eq(expected_json['golfCourseId']) }
        end
      end
    end
  end
end
