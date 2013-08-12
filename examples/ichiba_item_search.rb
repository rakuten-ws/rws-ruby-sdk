# encoding: utf-8

require 'rakuten_web_service'

developer_id = ARGV.shift
keyword = ARGV[0..-1].join(' ')

puts items = RakutenWebService::Ichiba::Item.search(:applicationId => developer_id, :keyword => keyword)

items.each do |item|
  puts "#{item['itemName']}, #{item['itemPrice']} yen"
end
