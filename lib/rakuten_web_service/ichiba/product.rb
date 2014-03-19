require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Product < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Product/Search/20140305'

      set_parser do |response|
        (response['Products'] || []).map { |prod| Product.new(prod) }
      end
    end
  end
end
