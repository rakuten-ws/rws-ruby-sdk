# frozen_string_literal: true

require 'rakuten_web_service/resource'
require 'rakuten_web_service/ichiba/item'

module RakutenWebService
  module Ichiba
    class Shop < Resource
      attribute :shopName, :shopCode, :shopUrl, :shopAffiliateUrl

      # Returns SearchResult object fetching Items of the Shop object.
      # @param parameters [Hash] input parameters to fetches items
      #   of the shop
      # @return [RakutenWebService::SearchResult]
      # @see RakutenWebService::Ichiba::Item
      def items(parameters = {})
        parameters = parameters.merge(shop_code: code)
        RakutenWebService::Ichiba::Item.search(parameters)
      end
    end
  end
end
