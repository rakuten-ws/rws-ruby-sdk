require 'rakuten_web_service/client'

module RakutenWebService
  module Ichiba
    class Item
      class << self
        def search(options)
          client.get(options)
        end

        private
        def endpoint
          'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20120805'
        end

        def client
          @client ||= RakutenWebService::Client.new(endpoint)
        end
      end
    end
  end
end
