require 'rakuten_web_service/resource'

module RakutenWebService
  module Travel
    class AreaClass < RakutenWebService::Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024'

      class LargeClass < AreaClass
        attribute :largeClassCode, :largeClassName

        def initialize(data)
          @params = data['largeClass'].first
        end
      end

      class MiddleClass < AreaClass
        attribute :middleClassCode, :middleClassName
      end

      class SmallClass < AreaClass
        attribute :smallClassCode, :smallClassName
      end

      class DetailClass < AreaClass
        attribute :detailClassCode, :detailClassName
      end

      set_parser do |response|
        response['areaClasses']['largeClasses'].map do |data|
          LargeClass.new(data)
        end
      end
    end
  end
end
