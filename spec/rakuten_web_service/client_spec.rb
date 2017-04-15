require 'spec_helper'

describe RakutenWebService::Client do
  let(:endpoint) { 'https://api.example.com/resources' }
  let(:resource_class) do
    double('resource_class', endpoint: endpoint)
  end
  let(:client) { RakutenWebService::Client.new(resource_class) }
  let(:application_id) { 'default_application_id' }
  let(:affiliate_id) { 'default_affiliate_id' }
  let(:expected_query) do
    { affiliateId: affiliate_id, applicationId: application_id, formatVersion: '2' }
  end
  let(:expected_response) do
    { body: '{"status":"ok"}' }
  end

  before do
    @expected_request = stub_request(:get, endpoint).
      with(query: expected_query,
           headers: { 'User-Agent' => "RakutenWebService SDK for Ruby v#{RWS::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])" }).
      to_return(expected_response)

    RakutenWebService.configure do |c|
      c.affiliate_id = 'default_affiliate_id'
      c.application_id = 'default_application_id'
    end
  end

  describe '#get' do
    context 'call get without any parameters' do
      before do
        client.get({})
      end

      specify 'call endpoint with default parameters' do
        expect(@expected_request).to have_been_made.once
      end
    end

    context 'call get with parameters' do
      let(:affiliate_id) { 'latest_affiliate_id' }
      let(:application_id) { 'latest_application_id' }

      before do
        client.get(affiliate_id: affiliate_id,
                   application_id: application_id)
      end

      specify 'call endpoint with given parameters' do
        expect(@expected_request).to have_been_made.once
      end
    end

    context "giving 'sort' option" do
      let(:expected_query) do
        {
          applicationId: application_id,
          affiliateId: affiliate_id,
          formatVersion: '2',
          sort: sort_option
        }
      end

      before do
        client.get(sort: sort_option)
      end

      context "Specifying asceding order" do
        let(:sort_option) { '+itemPrice' }

        specify "encodes '+' in sort option" do
          expect(@expected_request).to have_been_made.once
        end
      end
      context "Specifying descending order" do
        let(:sort_option) { '-itemPrice' }

        specify "encodes '+' in sort option" do
          expect(@expected_request).to have_been_made.once
        end
      end
    end
  end

  describe 'about exceptions' do
    context 'parameter error' do
      let(:expected_response) do
        { status: 400,
          body: '{"error": "wrong_parameter",
                               "error_description": "specify valid applicationId"}'
        }
      end

      specify 'raises WrongParameter exception' do
        expect { client.get({}) }.to raise_error(RWS::WrongParameter, 'specify valid applicationId')
      end

    end

    context 'Too many requests' do
      let(:expected_response) do
        { status: 429,
          body: '{ "error": "too_many_requests",
                      "error_description": "number of allowed requests has been exceeded for this API. please try again soon." }'
        }
      end

      specify 'raises TooManyRequests exception' do
        expect { client.get({}) }.to raise_error(RWS::TooManyRequests,
          'number of allowed requests has been exceeded for this API. please try again soon.')
      end
    end

    context 'Internal error in Rakuten Web Service' do
      let(:expected_response) do
        { status: 500,
          body: '{ "error": "system_error",
                                "error_description": "api logic error" }'
        }
      end

      specify 'raises SystemError exception' do
        expect { client.get({}) }.to raise_error(RWS::SystemError, 'api logic error')
      end
    end

    context 'Unavaiable due to maintainance or overloaded' do
      let(:expected_response) do
        { status: 503,
          body: '{ "error": "service_unavailable",
                                "error_description": "XXX/XXX is under maintenance" }'
        }
      end

      specify 'raises ServiceUnavailable exception' do
        expect { client.get({}) }.to raise_error(RWS::ServiceUnavailable, 'XXX/XXX is under maintenance')
      end
    end

    context 'The specified genre has no ranking data' do
      let(:expected_response) do
        { status: 404,
          body: '{ "error": "not_found",
                                "error_description": "This genre data does not exist"}'
        }
      end

      specify 'raises NotFound exception' do
        expect { client.get({}) }.to raise_error(RWS::NotFound, 'This genre data does not exist')
      end
    end
  end
end
