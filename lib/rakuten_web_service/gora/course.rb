# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Gora
    class Course < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Gora/GoraGolfCourseSearch/20170623'

      parser do |response|
        response['Items'].map { |item| new(item) }
      end

      attribute :golfCourseId, :golfCourseName, :golfCourseAbbr, :golfCourseNameKana, :golfCourseCaption,
                :address, :latitude, :longitude, :highway, :golfCourseDetailUrl, :reserveCalUrl, :ratingUrl,
                :golfCourseImageUrl, :evaluation
    end
  end
end
