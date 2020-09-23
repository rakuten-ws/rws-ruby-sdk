# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Gora
    class Plan < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Gora/GoraPlanSearch/20170623'

      parser do |response|
        response['Items'].map { |item| new(item) }
      end

      attribute :golfCourseId, :golfCourseName, :golfCourseAbbr, :golfCourseNameKana, :golfCourseCaption,
                :address, :latitude, :longitude, :highway, :golfCourseDetailUrl, :reserveCalUrl, :ratingUrl,
                :golfCourseImageUrl, :evaluation

      def plan_info
        get_attribute('planInfo').map { |plan| PlanInfo.new(plan['plan']) }
      end

      class PlanInfo < Resource
        class << self
          def search(_options)
            raise 'There is no API endpoint for this resource.'
          end
        end
        attribute :planId, :planName, :planType, :limitedTimeFlag, :price, :basePrice, :salesTax, :courseUseTax,
                  :otherTax, :playerNumMin, :playerNumMax, :startTimeZone, :round, :caddie, :cart, :assu2sum,:addFee2bFlag,
                  :addFee2b, :assortment2bFlag, :addFee3bFlag, :addFee3b, :assortment3bFlag, :discount4sumFlag, :lunch,
                  :drink, :stay, :lesson, :planOpenCompe, :compePlayGroupMin, :compePlayMemberMin, :compePrivilegeFree,
                  :compeOption, :other, :pointFlag, :point

        def call_info
          CallInfo.new(get_attribute('callInfo'))
        end

        class CallInfo < Resource
          class << self
            def search(_options)
              raise 'There is no API endpoint for this resource.'
            end
          end
          attribute :playDate, :stockStatus, :stockCount, :reservePageUrlPC, :reservePageUrlMobile
        end
      end
    end
  end
end
