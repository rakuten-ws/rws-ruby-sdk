module RakutenWebService
  module Recipe

    def large_categories
      categories('large')
    end

    def medium_categories
      categories('medium')
    end

    def small_categories
      categories('small')
    end

    def categories(category_type)
      Category.search(category_type: category_type).response['result'][category_type].map do |category|
        Category.new(category)
      end
    end

    module_function :large_categories, :medium_categories, :small_categories, :categories

    class Category < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20121121'

      attribute :categoryId, :categoryName, :categoryUrl
    end
  end
end
