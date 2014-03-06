require 'rakuten_web_service/search_result'

module RakutenWebService
  module Travel
    class SearchResult < RakutenWebService::SearchResult
      def has_next_page?
        false unless paging_info
        paging_info['page'] && paging_info['page'] < paging_info['pageCount']
      end

      def params_to_get_next_page
        @params.merge('page' => (paging_info['page'] + 1))
      end

      private
      def paging_info
        @response.body['pagingInfo']
      end
    end
  end
end
