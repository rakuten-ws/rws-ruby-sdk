require 'rakuten_web_service/search_result'

module RakutenWebService
  module Travel
    class SearchResult < RakutenWebService::SearchResult
      def params_to_get_next_page
        @params.merge('page' => (paging_info['page'] + 1))
      end

      using RakutenWebService::StringSupport

      %w[page pageCount recordCount].each do |name|
        method_name = name.to_snake
        define_method method_name do
          paging_info[name]
        end
      end

      def has_next_page?
        (page < page_count)
      end

      def next_page
        search(params_to_get_next_page)
      end

      private

      def paging_info
        response['pagingInfo']
      end
    end
  end
end
