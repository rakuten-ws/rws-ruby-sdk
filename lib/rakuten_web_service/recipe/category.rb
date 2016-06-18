module RakutenWebService
  class Recipe < Resource

    def self.large_categories
      categories('large')
    end

    def self.medium_categories
      categories('medium')
    end

    def self.small_categories
      categories('small')
    end

    def self.categories(category_type)
      Category.search(category_type: category_type).response['result'][category_type].map do |category|
        Category.new(category)
      end
    end

    class Category < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20121121'

      attribute :categoryId, :categoryName, :categoryUrl
    end
  end
end
