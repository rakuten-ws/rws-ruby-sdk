# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Tag < Resource
      attribute :tagId, :tagName, :parentTagId

      def search
        RakutenWebService::Ichiba::Item.search({tagId: id})
      end
    end
  end
end
