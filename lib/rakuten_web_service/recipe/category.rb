module RakutenWebService
  module Recipe

    def large_categories
      Category.search(category_type: 'large').response['result']['large'].map do |category|
        Category.new(category)
      end
    end

    module_function :large_categories

    class Category < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20121121'

      attribute :categoryId, :categoryName, :categoryUrl
    end
  end
end
