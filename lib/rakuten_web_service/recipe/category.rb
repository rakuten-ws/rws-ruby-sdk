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
      @categories ||= {}
      @categories[category_type] ||= Category.search(category_type: category_type).response['result'][category_type].map do |category|
                                       Category.new(category)
                                     end
    end

    class << self
      protected :search
    end

    class Category < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20121121'

      attribute :categoryId, :categoryName, :categoryUrl, :parentCategoryId, :categoryType

      def parent_category
        return if parent_category_type.nil?
        Recipe.categories(parent_category_type).find { |c| c.id === parent_category_id }
      end

      private
        def parent_category_type
          case type
          when 'small' then 'medium'
          when 'medium' then 'large'
          else
            nil
          end
        end
    end
  end
end
