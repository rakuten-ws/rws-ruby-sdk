require 'spec_helper'

describe RakutenWebService::Gora::CourseDetail do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Gora/GoraGolfCourseDetail/20170623' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
        affiliateId: affiliate_id,
        applicationId: application_id,
        formatVersion: '2',
        golfCourseId: 120092
    }
  end

  before do
    RakutenWebService.configure do |c|
      c.affiliate_id = affiliate_id
      c.application_id = application_id
    end
  end

  describe '#find' do
    before do
      response = JSON.parse(fixture('gora/course_detail_search.json'))
      @expected_request = stub_request(:get, endpoint).
          with(query: expected_query).to_return(body: response.to_json)
    end

    context 'call the find method' do
      describe 'a respond object' do
        let(:expected_json) do
          response = JSON.parse(fixture('gora/course_detail_search.json'))
          response['Item']
        end

        subject { RakutenWebService::Gora::CourseDetail.find(expected_query[:golfCourseId]) }

        it { is_expected.to be_a RakutenWebService::Gora::CourseDetail }

        specify 'should be accessed by key' do
          expect(subject['golfCourseName']).to eq(expected_json['golfCourseName'])
          expect(subject['golf_course_name']).to eq(expected_json['golfCourseName'])
        end

        describe '#golf_course_name' do
          subject { super().golf_course_name }
          it { is_expected.to eq(expected_json['golfCourseName']) }
        end

        specify 'should be accessed to ratings' do
          expect(subject.ratings.size).to eq(expected_json['ratings'].size)
          expect(subject.ratings.first.nick_name).to eq(expected_json['ratings'].first['nickName'])
        end

        specify 'should be accessed to new_plans' do
          expect(subject.new_plans.size).to eq(expected_json['newPlans'].size)
          expect(subject.new_plans.first.name).to eq(expected_json['newPlans'].first['planName'])
        end
      end
    end
  end
end
