# frozen_string_literal: true

require 'rakuten_web_service/string_support'

module RakutenWebService
  class Configuration
    attr_accessor :application_id, :affiliate_id, :max_retries, :debug, :access_key

    def initialize
      @application_id = ENV['RWS_APPLICATION_ID']
      @affiliate_id = ENV['RWS_AFFILIATE_ID']
      @max_retries = 5
      @access_key = ENV['RWS_ACCESS_KEY']
    end

    def generate_parameters(params)
      convert_snake_key_to_camel_key(default_parameters.merge(params))
    end

    def default_parameters
      raise 'Application ID and access key are not defined' unless has_required_options?
      { application_id: application_id, affiliate_id: affiliate_id, format_version: '2' }
    end

    def has_required_options?
      application_id && application_id != '' && access_key && access_key != ''
    end

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
