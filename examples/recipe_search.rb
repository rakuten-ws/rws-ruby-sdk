require 'rakuten_web_service'

application_id = ARGV.shift
keyword = ARGV[0..-1].join(' ')

RakutenWebService.configure do |c|
  c.application_id = application_id
end

category = RakutenWebService::Recipe.small_categories.find { |c| c.name.match(keyword) }

recipes = category.ranking

recipes.first(10).each do |recipe|
  puts "#{recipe.title} is made by #{recipe.nickname}"
end
