# frozen_string_literal: true

module RakutenWebService
  class AllProxy
    include Enumerable

    def initialize(search_result)
      @search_result = search_result
    end

    def each
      search_result = @search_result
      loop do
        search_result.each do |resource|
          yield resource
        end
        break unless search_result.next_page?

        search_result = search_result.next_page
      end
    end
  end
end
