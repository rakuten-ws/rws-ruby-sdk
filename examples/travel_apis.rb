require 'rakuten_web_service'

application_id = ARGV.shift

RakutenWebService.configure do |c|
  c.application_id = application_id
end

tokyo = RakutenWebService::Travel::AreaClass::SmallClass['tokyo']

nikotama = tokyo.children.find do |detail_area|
  detail_area.class_name =~ /二子玉川/
end

puts "#{nikotama.class_code}: #{nikotama.class_name}"

nikotama.search(responseType: 'large').first(3).each do |hotel|
  puts "#{hotel.basic_info['hotelName']} \n\t#{hotel.basic_info['address1']} #{hotel.basic_info['address2']}"
end
