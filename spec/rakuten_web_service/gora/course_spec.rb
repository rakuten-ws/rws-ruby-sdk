require 'spec_helper'

describe RakutenWebService::Gora::Course do
  let(:endpoint) { 'https://app.rakuten.co.jp/services/api/Gora/GoraGolfCourseSearch/20170623' }
  let(:affiliate_id) { 'dummy_affiliate_id' }
  let(:application_id) { 'dummy_application_id' }
  let(:expected_query) do
    {
        affiliateId: affiliate_id,
        applicationId: application_id,
        formatVersion: '2',
        keyword: '軽井沢'
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
      response = JSON.parse(fixture('gora/course_search_with_Karuizawa.json'))
      response['pageCount'] = 2
      @expected_request = stub_request(:get, endpoint).
          with(query: expected_query).to_return(body: response.to_json)

      response['page'] = 2
      response['first'] = 31
      response['last'] = 60
      @second_request = stub_request(:get, endpoint).
          with(query: expected_query.merge(page: 2)).
          to_return(body: response.to_json)
    end

    context 'just call the search method' do
      before do
        @courses = RakutenWebService::Gora::Course.search(keyword: '軽井沢')
      end

      specify 'endpoint should not be called' do
        expect(@expected_request).to_not have_been_made
      end

      describe 'a respond object' do
        let(:expected_json) do
          response = JSON.parse(fixture('gora/course_search_with_Karuizawa.json'))
          response['Items'][0]
        end

        subject { @courses.first }

        it { is_expected.to be_a RakutenWebService::Gora::Course }
        specify 'should be accessed by key' do
          expect(subject['golfCourseName']).to eq(expected_json['golfCourseName'])
          expect(subject['golf_course_name']).to eq(expected_json['golfCourseName'])
        end

        describe '#golf_course_name' do
          subject { super().golf_course_name }
          it { is_expected.to eq(expected_json['golfCourseName']) }
        end
      end

      context 'after that, call each' do
        before do
          @courses.each { |i| i }
        end

        specify 'endpoint should be called' do
          expect(@expected_request).to have_been_made.once
          expect(@second_request).not_to have_been_made.once
        end
      end

      context 'after that, call fetch_result' do
        before do
          @courses.fetch_result
        end

        specify 'endpoint should be called' do
          expect(@expected_request).to have_been_made.once
          expect(@second_request).to_not have_been_made.once
        end
      end

      describe '#all' do
        before do
          @courses.all
        end

        specify 'endpoint should not be called' do
          expect(@expected_request).to_not have_been_made.once
          expect(@second_request).to_not have_been_made.once
        end

        context 'call an enumerable method like each' do
          before do
            @courses.all.each { |i| i.to_s }
          end

          specify 'endpoint should be called' do
            expect(@expected_request).to have_been_made.once
            expect(@second_request).to have_been_made.once
          end
        end
      end
    end
  end
end
