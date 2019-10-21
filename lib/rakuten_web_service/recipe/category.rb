# frozen_string_literal: true

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
        Category.new(category.merge(categoryType: category_type))
      end
    end

    class << self
      protected :search
    end

    class Category < Resource
      endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426'

      attribute :categoryId, :categoryName, :categoryUrl, :parentCategoryId, :categoryType

      def ranking
        Recipe.ranking(absolute_category_id)
      end

      def parent_category
        return nil if parent_category_type.nil?
        Recipe.categories(parent_category_type).find do |c|
          c.id.to_i == parent_category_id.to_i
        end
      end

      def absolute_category_id
        if parent_category
          [parent_category.absolute_category_id, id.to_s].join('-')
        else
          id.to_s
        end
      end

      private

      def parent_category_type
        case type
        when 'small' then 'medium'
        when 'medium' then 'large'
        end
      end
    end
  end
end
