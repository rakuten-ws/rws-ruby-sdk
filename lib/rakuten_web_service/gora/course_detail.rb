# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Gora
    class CourseDetail < Resource
      class << self
        def find(golf_course_id)
          search(golfCourseId: golf_course_id).first
        end
      end

      endpoint 'https://app.rakuten.co.jp/services/api/Gora/GoraGolfCourseDetail/20170623'

      set_parser do |response|
        [new(response['Item'])]
      end

      attribute :carrier, :golfCourseId, :golfCourseName, :golfCourseAbbr, :golfCourseNameKana, :golfCourseCaption,
                :information, :highway, :ic, :icDistance, :latitude, :longitude, :postalCode, :address, :telephoneNo,
                :faxNo, :openDay, :closeDay, :creditCard, :shoes, :dressCode, :practiceFacility, :lodgingFacility,
                :otherFacility, :golfCourseImageUrl1, :golfCourseImageUrl2, :golfCourseImageUrl3, :golfCourseImageUrl4,
                :golfCourseImageUrl5, :weekdayMinPrice, :baseWeekdayMinPrice, :holidayMinPrice, :baseHolidayMinPrice,
                :designer, :courseType, :courseVerticalInterval, :dimension, :green, :greenCount, :holeCount, :parCount,
                :courseName, :courseDistance, :longDrivingContest, :nearPin, :ratingNum, :evaluation, :staff, :facility,
                :meal, :course, :costperformance, :distance, :fairway, :reserveCalUrl, :voiceUrl, :layoutUrl, :routeMapUrl

      def ratings
        get_attribute('ratings').map { |rating| Rating.new(rating) }
      end

      def new_plans
        get_attribute('newPlans').map { |plan| Plan.new(plan) }
      end

      class Rating < Resource
        class << self
          def search(_options)
            raise 'There is no API endpoint for this resource.'
          end
        end
        attribute :title, :nickName, :prefecture, :age, :sex, :times, :evaluation, :staff, :facility, :meal, :course,
                  :costperformance, :distance, :fairway, :comment
      end

      class Plan < Resource
        class << self
          def search(_options)
            raise 'There is no API endpoint for this resource.'
          end
        end
        attribute :month, :planName, :planDate, :service, :price, :basePrice, :salesTax, :courseUseTax, :otherTax
      end
    end
  end
end
