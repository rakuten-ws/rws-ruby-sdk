# frozen_string_literal: true

require 'rakuten_web_service/resource'

module RakutenWebService
  module Ichiba
    class Tag < Resource
      attribute :tagId, :tagName, :parentTagId
    end
  end
end
