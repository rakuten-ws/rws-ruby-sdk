require 'faraday'
require 'faraday_middleware'

module RakutenWebService
  class WrongParameter < StandardError; end
  class NotFound < StandardError; end
  class TooManyRequests < StandardError; end
  class SystemError < StandardError; end
  class ServiceUnavailable < StandardError; end

  class Client
    attr_reader :url, :path

    def initialize(endpoint)
      url = URI.parse(endpoint)
      @url = "#{url.scheme}://#{url.host}"
      @path = url.path
    end

    def get(query)
      query = RakutenWebService.configuration.generate_parameters.merge(query)
      query = convert_snake_key_to_camel_key(query)
      response = connection.get(path, query)
      case response.status
      when 200
        return response
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
        conn.adapter Faraday.default_adapter
        conn.headers['User-Agent'] = "RakutenWebService SDK for Ruby-#{RWS::VERSION}"
      end
    end

    def convert_snake_key_to_camel_key(params)
      converted = {}
      params.each do |k, v|
        k = k.to_s.gsub(/([a-z]+)_([a-z]+)/) { "#{$1}#{$2.capitalize}" }
        converted[k] = v
      end
      return converted
    end
  end
end
