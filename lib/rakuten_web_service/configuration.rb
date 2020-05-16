# frozen_string_literal: true

require 'rakuten_web_service/string_support'

module RakutenWebService
  class Configuration
    # Application ID issued for your client
    # @return [String]
    # @see https://webservice.rakuten.co.jp/app/create
    attr_accessor :application_id

    # Affiliate ID
    # @return [String]
    # @see https://affiliate.rakuten.co.jp/
    attr_accessor :affiliate_id

    # This value sets how much RakutenWebService::SearchResult tries to send a request.
    # When all tries fail, RakutenWebService::SearchResult raises TooManyRequests.
    # @return [Integer]
    # @see RakutenWebService::SearchResult
    attr_accessor :max_retries

    # Sets debug mode. When debug mode is on, all http requests and responses are printed to STDERR.
    #
    # @return [Boolean] true if debug mode is on, otherwise false
    # @see https://docs.ruby-lang.org/ja/latest/method/Net=3a=3aHTTP/i/set_debug_output.html Net::HTTP#set_debug_output
    attr_accessor :debug

    def initialize
      @application_id = ENV['RWS_APPLICATION_ID']
      @affiliate_id = ENV['RWS_AFFILIATE_ID']
      @max_retries = 5
    end

    def generate_parameters(params)
      convert_snake_key_to_camel_key(default_parameters.merge(params))
    end

    def default_parameters
      raise 'Application ID is not defined' unless has_required_options?

      { application_id: application_id, affiliate_id: affiliate_id, format_version: '2' }
    end

    def has_required_options?
      application_id && application_id != ''
    end

    # Setting `configuration.debug` true or defining the environment variable `RWS_SDK_DEBUG` sets debug mode on.
    #
    # @return [Boolean] true if debug mode is on
    def debug_mode?
      ENV.key?('RWS_SDK_DEBUG') || debug
    end

    private

    using RakutenWebService::StringSupport

    def convert_snake_key_to_camel_key(params)
      params.inject({}) do |h, (k, v)|
        k = k.to_s.to_camel
        h[k] = v
        h
      end
    end
  end
end
