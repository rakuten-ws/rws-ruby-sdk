require 'rakuten_web_service/resource'
require 'rakuten_web_service/travel/search_result'

module RakutenWebService
  module Travel
    class Resource < RakutenWebService::Resource
      def self.search(options)
        RakutenWebService::Travel::SearchResult.new(options, self)
      end
    end
  end
end
