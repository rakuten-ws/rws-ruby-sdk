# frozen_string_literal: true

module RakutenWebService
  class GenreInformation
    attr_reader :parent, :current, :children

    def initialize(params, genre_class)
      @parent = Array(params['parent']).first
      @parent = genre_class.new(@parent) if @parent
      @current = Array(params['current']).first
      @current = genre_class.new(@current) if @current
      @children = params['children'].map { |child| genre_class.new(child['child']) }
    end
  end
end
