# frozen_string_literal: true

module RakutenWebService
  module StringSupport
    refine String do
      def to_snake
        gsub(/([a-z]+)([A-Z]{1})/, '\1_\2').downcase
      end

      def to_camel
        gsub(/([a-z]{1})_([a-z]{1})/) do |matched|
          matched = matched.split('_')
          matched[0] + matched[1].capitalize
        end
      end
    end
  end
end
