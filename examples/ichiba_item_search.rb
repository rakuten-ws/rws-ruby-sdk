# encoding: utf-8

require 'rakuten_web_service'

application_id = ARGV.shift
keyword = ARGV[0..-1].join(' ')

RakutenWebService.configuration do |c|
  c.application_id = application_id
end

items = RakutenWebService::Ichiba::Item.search(:keyword => keyword)

items.first(10).each do |item|
  puts "#{item['itemName']}, #{item['itemPrice']} yen"
end
