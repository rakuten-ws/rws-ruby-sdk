# frozen_string_literal: true

module RakutenWebService
  module StringSupport
    refine String do
      def to_snake
        gsub(/([a-z]+)([A-Z]{1})/, '\1_\2').downcase
      end

      def to_camel
        gsub(/([a-z]{1})_([a-z]{1})/) { "#{$1}#{$2.capitalize}" }
      end
    end
  end
end