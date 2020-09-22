# frozen_string_literal: true

require 'rakuten_web_service/configuration'

require 'rakuten_web_service/recipe/category'

module RakutenWebService
  class Recipe < Resource
    endpoint 'https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426'

    attribute :recipeId, :recipeTitle, :recipeUrl,
      :foodImageUrl, :mediumImageUrl, :smallImageUrl,
      :pickup, :shop, :nickname,
      :recipeDescription, :recipeMaterial,
      :recipeIndication, :recipeCost,
      :recipePublishday, :rank

    parser do |response|
      response['result'].map { |r| Recipe.new(r) }
    end

    def self.ranking(category_id = nil)
      params = {}
      params = params.merge(category_id: category_id) unless category_id.nil?
      search(params)
    end

    class << self
      protected :search
    end
  end
end
