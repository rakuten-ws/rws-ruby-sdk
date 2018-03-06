# frozen_string_literal: true

require 'rakuten_web_service/resource'
require 'rakuten_web_service/ichiba/item'

module RakutenWebService
  module Ichiba
    class Shop < Resource
      attribute :shopName, :shopCode, :shopUrl, :shopAffiliateUrl

      def items(options = {})
        options = options.merge(shop_code: code)
        RakutenWebService::Ichiba::Item.search(options)
      end
    end
  end
end
