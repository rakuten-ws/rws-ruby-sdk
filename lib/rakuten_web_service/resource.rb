require 'rakuten_web_service/search_result'

module RakutenWebService
  class Resource
    class << self
      def attribute(*attributes)
        attributes.each do |attribute|
          method_name = attribute.to_s.gsub(/([a-z]+)([A-Z]{1})/) do |matched|
            "#{$1}_#{$2.downcase}"
          end
          method_name = method_name.sub(/^#{resource_name}_(\w+)$/) { $1 }
          self.class_eval <<-CODE
            def #{method_name}
              @params['#{attribute.to_s}']
            end
          CODE
        end
      end

      def search(options)
        SearchResult.new(options, self, client)
      end

      def resource_name
        self.name.split('::').last.downcase
      end

      def endpoint(url=nil)
        @endpoint = url || @endpoint 
      end

      def client
        @client ||= RakutenWebService::Client.new(endpoint)
      end

      def set_parser(&block)
        @parse_proc = block
      end

      def parse_response(response)
        @parse_proc.call(response)
      end
    end

    def initialize(params)
      @params = params
    end

    def [](key)
      camel_key = key.gsub(/([a-z]+)_(\w{1})/) { "#{$1}#{$2.capitalize}" }
      @params[key] || @params[camel_key]
    end
  end
end
