require 'rakuten_web_service'

application_id = ARGV.shift
keyword = ARGV[0..-1].join(' ')

RakutenWebService.configure do |c|
  c.application_id = application_id
end

items = RakutenWebService::Ichiba::Item.search(keyword: keyword)

items.first(10).each do |item|
  puts "#{item.name}, #{item.price} yen"
end
