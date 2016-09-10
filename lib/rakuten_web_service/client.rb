require 'uri'
require 'json'
require 'rakuten_web_service/response'
require 'rakuten_web_service/error'

module RakutenWebService
  class Client
    attr_reader :url

    def initialize(resource_class)
      @resource_class = resource_class
      @url = URI.parse(@resource_class.endpoint)
    end

    def get(params)
      params = RakutenWebService.configuration.generate_parameters(params)
      response = request(url.path, params)
      body = JSON.parse(response.body)
      case response.code.to_i
      when 200
        return RakutenWebService::Response.new(@resource_class, body)
      when 400
        raise WrongParameter, body['error_description']
      when 404
        raise NotFound, body['error_description']
      when 429
        raise TooManyRequests, body['error_description']
      when 500
        raise SystemError, body['error_description']
      when 503
        raise ServiceUnavailable, body['error_description']
      end
    end

    private
    def request(path, params)
      http = Net::HTTP.new(@url.host, @url.port)
      http.use_ssl = true
      path = "#{path}?#{params.map { |k, v| "#{k}=#{URI.encode(v.to_s)}" }.join('&')}"
      header = {
        'User-Agent' => "RakutenWebService SDK for Ruby v#{RWS::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"
      }
      http.get(path, header)
    end
  end
end
