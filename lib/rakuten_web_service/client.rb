# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'cgi'
require 'json'
require 'rakuten_web_service/response'
require 'rakuten_web_service/error'

module RakutenWebService
  class Client
    USER_AGENT = "RakutenWebService SDK for Ruby v#{RWS::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])".freeze

    attr_reader :url

    def initialize(resource_class)
      @resource_class = resource_class
      @url = URI.parse(@resource_class.endpoint)
    end

    def get(params)
      params = RakutenWebService.configuration.generate_parameters(params)
      response = request(url.path, params)
      body = JSON.parse(response.body)
      unless response.is_a?(Net::HTTPSuccess)
        raise RakutenWebService::Error.for(response)
      end

      RakutenWebService::Response.new(@resource_class, body)
    end

    private

    def request(path, params)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      if RakutenWebService.configuration.debug_mode?
        http.set_debug_output($stderr)
      end
      path = "#{path}?#{URI.encode_www_form(params)}"
      header = { 'User-Agent' => USER_AGENT }
      http.get(path, header)
    end
  end
end
