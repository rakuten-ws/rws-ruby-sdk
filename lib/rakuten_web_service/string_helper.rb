module RakutenWebService
  module StringHelper
    def to_camelcase(str)
      str = str.downcase
      str = str.gsub(/([a-z]+)_(\w{1})/) do
        "#{$1}#{$2.capitalize}"
      end
      str[0] = str[0].downcase
      str
    end

    def to_snakecase(str)
      str.gsub(/([a-z\d])([A-Z])/) { "#{$1}_#{$2}" }.
        tr('-', '_').
        downcase
    end
  end
end
