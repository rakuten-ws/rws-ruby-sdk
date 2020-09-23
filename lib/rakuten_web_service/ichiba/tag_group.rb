# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class TagGroup < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaTag/Search/20140222'

      parser do |response|
        response['tagGroups'].map { |tag_group| TagGroup.new(tag_group) }
      end

      attribute :tagGroupName, :tagGroupId

      def tags
        get_attribute('tags').map do |tag|
          Tag.new(tag)
        end
      end
    end
  end
end
