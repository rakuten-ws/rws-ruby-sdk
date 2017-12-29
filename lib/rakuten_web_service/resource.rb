require 'rakuten_web_service/client'
require 'rakuten_web_service/search_result'

module RakutenWebService
  class Resource
    class << self
      def attribute(*attributes)
        attributes.each do |attribute|
          method_name = attribute.to_s.gsub(/([a-z]+)([A-Z]{1})/) do |_|
            "#{$1}_#{$2}"
          end.downcase
          method_name = method_name.sub(/^#{resource_name}_(\w+)$/) { $1 }
          instance_eval do
            define_method method_name do
              get_attribute(attribute.to_s)
            end
          end
          if method_name =~ /(.+)_flag$/
            instance_eval do
              define_method "#{$1}?" do
                get_attribute(attribute.to_s) == 1
              end
            end
          end
        end
      end

      def search(options)
        SearchResult.new(options, self)
      end

      def all(options, &block)
        if block
          search(options).all(&block)
        else
          search(options).all
        end
      end

      def resource_name
        @resource_name ||= self.name.split('::').last.downcase
      end

      def set_resource_name(name)
        @resource_name = name
      end

      def endpoint(url=nil)
        @endpoint = url || @endpoint
      end

      def client
        @client ||= RakutenWebService::Client.new(endpoint)
      end

      def set_parser(&block)
        instance_eval do
          define_singleton_method :parse_response, block
        end
      end
    end

    def initialize(params)
      @params = {}
      params.each { |k, v| @params[k.to_s] = v }
    end

    def [](key)
      camel_key = key.gsub(/([a-z]+)_(\w{1})/) { "#{$1}#{$2.capitalize}" }
      @params[key] || @params[camel_key]
    end

    def get_attribute(name)
      @params[name.to_s]
    end

    def attributes
      params.keys
    end

    def ==(genre)
      raise ArgumentError unless genre.is_a?(RakutenWebService::Resource)

      self.params.keys.all? do |k|
        @params[k] == genre.params[k]
      end
    end

    protected
      def params
        @params
      end
  end
end
