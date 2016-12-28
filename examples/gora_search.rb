# This is a sample script of Rakuten Gora APIs.
# RWS Ruby SDK supports Gora API. The inteface is similar to ones Ichiba API.
# If you want to search courses dealt in Rakuten Gora, you can do it with `RakutenWebService::Gora::Course`.
# As for other resources, there are `RakutenWebService::Gora::CourseDetail`, `RakutenWebService::Gora::Plan` and so on.
# Please refer to the following documents if you want more detail of input/output parameters:
#   http://webservice.rakuten.co.jp/document/
#

require 'rakuten_web_service'
require 'date'

application_id = ARGV.shift
keyword = ARGV.shift || '軽井沢'

RakutenWebService.configure do |c|
  c.application_id = application_id
end

c = RakutenWebService::Gora::Course.search(keyword: keyword).first
id = c.golf_course_id
puts id
puts c.golf_course_name
puts c.address

d = RakutenWebService::Gora::CourseDetail.find(id)
puts d.green
puts d.green_count
puts d.course_distance
puts d.long_driving_contest
puts d.near_pin
puts d.evaluation
d.new_plans.each do |p|
  puts "  #{p.month}: #{p.name}"
end

next_week = Date.today + 7
chiba_and_kanagawa = '12,14'
plans = RWS::Gora::Plan.search(areaCode: chiba_and_kanagawa, playDate: next_week.strftime('%Y-%m-%d'))
plans.first(5).each { |p|
  puts "#{p.golf_course_id}, #{p.golf_course_name}"
  p.plan_info.each { |pi|
    puts "  #{pi.plan_id}, #{pi.plan_name}, #{pi.price}"
    ci = pi.call_info
    puts "    #{ci.play_date}, #{ci.stock_status}"
  }
}
