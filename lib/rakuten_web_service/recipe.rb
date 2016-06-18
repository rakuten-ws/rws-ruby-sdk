require 'rakuten_web_service/configuration'

require 'rakuten_web_service/recipe/category'

module RakutenWebService
  class Recipe < Resource
    endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20121121'

    attribute :recipeId, :recipeTitle, :recipeUrl,
      :foodImageUrl, :mediumImageUrl, :smallImageUrl,
      :pickup, :shop, :nickname,
      :recipeDescription, :recipeMaterial,
      :recipeIndication, :recipeCost,
      :recipePublishday, :rank

    class << self
      private :search
    end
  end
end
