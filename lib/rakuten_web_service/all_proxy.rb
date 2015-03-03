module RakutenWebService
  class AllProxy
    include Enumerable

    def initialize(search_result)
      @search_result = search_result
    end

    def each
      search_result = @search_result
      response = search_result.query
      loop do
        response.each do |resource|
          yield resource
        end
        break unless response.has_next_page?
        response = search_result.search('page' => response.page + 1)
      end
    end
  end
end
