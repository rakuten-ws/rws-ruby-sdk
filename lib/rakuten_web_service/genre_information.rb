module RakutenWebService
  class GenreInformation
    attr_reader :parent, :current, :children

    def initialize(params)
      @parent = Array(params['parent']).first
      @current = Array(params['current']).first
      @current = RWS::Ichiba::Genre.new(@current) if @current
      @children = params['children'].map { |child| RWS::Ichiba::Genre.new(child['child']) }
    end
  end
end
