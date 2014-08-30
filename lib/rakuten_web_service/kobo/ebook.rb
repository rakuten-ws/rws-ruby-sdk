# encoding: utf-8

require 'rakuten_web_service/resource'

module RakutenWebService
  module Kobo
    class Ebook < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Kobo/EbookSearch/20131010'

      set_parser do |response|
        response['Items'].map { |i| self.new(i['Item']) }
      end
    end
  end
end
