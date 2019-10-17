# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Tag < Resource
      attribute :tagId, :tagName, :parentTagId

      def search(params = {})
        params = params.merge(tagId: id)
        RakutenWebService::Ichiba::Item.search(params)
      end
    end
  end
end
