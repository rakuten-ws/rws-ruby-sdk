require 'faraday'
require 'faraday_middleware'

require 'rakuten_web_service/response'

module RakutenWebService
  class WrongParameter < StandardError; end
  class NotFound < StandardError; end
  class TooManyRequests < StandardError; end
  class SystemError < StandardError; end
  class ServiceUnavailable < StandardError; end

  class Client
    attr_reader :url, :path

    def initialize(resource_class)
      @resource_class = resource_class
      url = URI.parse(@resource_class.endpoint)
      @url = "#{url.scheme}://#{url.host}"
      @path = url.path
    end

    def get(params)
      params = RakutenWebService.configuration.generate_parameters(params)
      response = connection.get(path, params)
      case response.status
      when 200
        return RakutenWebService::Response.new(@resource_class, response.body)
      when 400
        raise WrongParameter, response.body['error_description']
      when 404
        raise NotFound, response.body['error_description']
      when 429
        raise TooManyRequests, response.body['error_description']
      when 500
        raise SystemError, response.body['error_description']
      when 503
        raise ServiceUnavailable, response.body['error_description']
      end
    end

    private
    def connection
      return @connection if @connection
      @connection = Faraday.new(:url => url) do |conn|
        conn.request :url_encoded
        conn.response :json
        conn.response :logger if RakutenWebService.configuration.debug
        conn.adapter Faraday.default_adapter
        conn.headers['User-Agent'] = "RakutenWebService SDK for Ruby-#{RWS::VERSION}"
      end
    end
  end
end
