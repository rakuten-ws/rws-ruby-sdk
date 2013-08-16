require 'faraday'
require 'faraday_middleware'

module RakutenWebService
  class Client
    attr_reader :url, :path

    def initialize(endpoint)
      url = URI.parse(endpoint)
      @url = "#{url.scheme}://#{url.host}"
      @path = url.path
    end

    def get(query)
      query = convert_snake_key_to_camel_key(query)
      connection.get(path, query)
    end

    private
    def connection
      return @connection if @connection
      @connection = Faraday.new(:url => url) do |conn|
        conn.request :url_encoded
        conn.response :json
        conn.adapter Faraday.default_adapter
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
