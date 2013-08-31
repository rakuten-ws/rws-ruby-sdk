# RakutenWebService

[![Build Status](https://travis-ci.org/satoryu/rakuten_web_service.png?branch=master)](https://travis-ci.org/satoryu/rakuten_web_service) [![Gem Version](https://badge.fury.io/rb/rakuten_web_service.png)](http://badge.fury.io/rb/rakuten_web_service)

## Installation

Add this line to your application's Gemfile:

    gem 'rakuten_web_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rakuten_web_service

## Usage

Now rakuten\_web\_service is supporting the following APIs: 

* [Rakuten Ichiba Item Search API](http://webservice.rakuten.co.jp/api/ichibaitemsearch/)
* [Rakuten Ichiba Genre Search API](http://webservice.rakuten.co.jp/api/ichibagenresearch/)
* [Rakuten Ichiba Ranking API](http://webservice.rakuten.co.jp/api/ichibaitemranking/)

## Configuration

`RakutenWebService.configuration` allows you to specify your application's key called application\_id and your affiliate id(optional). 

    RakutenWebService.configuration do |c|
      c.application_id = YOUR_APPLICATION_ID
      c.affiliate_id = YOUR_AFFILIATE_ID
    end

### Search Ichiba Items

    items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby') # This returns Enamerable object
    items.first(10).each do |item|
      puts "#{item['itemName']}, #{item.price} yen" # You can refer to values as well as Hash. 
    end

### Genre

Genre class provides an interface to traverse sub genres.

    root = RakutenWebService::Ichiba::Genre.root # root genre
    # children returns sub genres
    root.children.each do |child|
      puts "[#{child.id}] #{child.name}"
    end
    
    # Use genre id to fetch genre object
    RakutenWebService::Ichiba::Genre[100316].name # => "水・ソフトドリンク"


### Ichiba Item Ranking

    RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 0) # returns the TOP 30 items for Male in 30s
    RakutenWebService::Ichiba::Genre[100316].ranking # the TOP 30 items in "水・ソフトドリンク" genre

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
