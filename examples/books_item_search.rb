# This is a sample script of Rakuten Books APIs.
# RWS Ruby SDK supports Books API. The inteface is similar to ones Ichiba API.
# If you want to search CDs dealt in Rakuten Books, you can do it with `RakutenWebService::Books::CD`.
# As for other resources, there are `RakutenWebService::Books::Book`, `RakutenWebService::Books::DVD` and so on.
# Please refer to the following documents if you want more detail of input/output parameters:
#   http://webservice.rakuten.co.jp/document/
#

require 'rakuten_web_service'

application_id = ARGV.shift
keyword = ARGV[0..-1].join(' ')

RakutenWebService.configure do |c|
  c.application_id = application_id
end

cds = RakutenWebService::Books::CD.search(title: keyword)

cds.first(10).each do |cd|
  puts "#{cd.title} (#{cd.title_kana}):\n\t #{cd.play_list}"
end
