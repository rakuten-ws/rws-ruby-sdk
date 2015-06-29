# RakutenWebService

[![Build Status](https://travis-ci.org/rakuten-ws/rws-ruby-sdk.png?branch=master)](https://travis-ci.org/rakuten-ws/rws-ruby-sdk) [![Gem Version](https://badge.fury.io/rb/rakuten_web_service.png)](http://badge.fury.io/rb/rakuten_web_service)


## Installation

Add this line to your application's Gemfile:

```ruby
  gem 'rakuten_web_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rakuten_web_service


Now rakuten\_web\_service is supporting the following APIs:

### Rakuten Ichiba APIs

* [Rakuten Ichiba Item Search API](http://webservice.rakuten.co.jp/api/ichibaitemsearch/)
* [Rakuten Ichiba Genre Search API](http://webservice.rakuten.co.jp/api/ichibagenresearch/)
* [Rakuten Ichiba Ranking API](http://webservice.rakuten.co.jp/api/ichibaitemranking/)
* [Rakuten Product API](http://webservice.rakuten.co.jp/api/productsearch/)


### Rakuten Books APIs

* [Rakuten Books Total Search API](http://webservice.rakuten.co.jp/api/bookstotalsearch/)
* [Rakuten Books Book Search API](http://webservice.rakuten.co.jp/api/booksbooksearch/)
* [Rakuten Books CD Search API](http://webservice.rakuten.co.jp/api/bookscdsearch/)
* [Rakuten Books DVD/Blu-ray Search API](http://webservice.rakuten.co.jp/api/booksdvdsearch/)
* [Rakuten Books ForeignBook Search API](http://webservice.rakuten.co.jp/api/booksforeignbooksearch/)
* [Rakuten Books Magazine Search API](http://webservice.rakuten.co.jp/api/booksmagazinesearch/)
* [Rakuten Books Game Search API](http://webservice.rakuten.co.jp/api/booksgamesearch/)
* [Rakuten Books Software Search API](http://webservice.rakuten.co.jp/api/bookssoftwaresearch/)
* [Rakuten Books Genre Search API](http://webservice.rakuten.co.jp/api/booksgenresearch/)

### Rakuten Kobo APIs

* [Rakuten Kobo Ebook Search API](http://webservice.rakuten.co.jp/api/koboebooksearch/)
* [Rakuten Kobo Genre Search API](http://webservice.rakuten.co.jp/api/kobogenresearch/)

## Usage

### Prerequisite: Getting Application ID

You need to get Application ID for your application to access to Rakuten Web Service APIs. 
If you have not got it, register your appplication [here](https://webservice.rakuten.co.jp/app/create). 

### Configuration

`RakutenWebService.configuration` allows you to specify your application's key called application\_id and your affiliate id(optional).

```ruby
  RakutenWebService.configuration do |c|
    c.application_id = 'YOUR_APPLICATION_ID'
    c.affiliate_id = 'YOUR_AFFILIATE_ID'
  end
```

Please note that you neet to replace `'YOUR_APPLICATION_ID'` and `'YOUR_AFFILIATE_ID'` with actual ones you have.

### Search Ichiba Items

```ruby
  items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby') # This returns Enumerable object
  items.first(10).each do |item|
    puts "#{item['itemName']}, #{item.price} yen" # You can refer to values as well as Hash.
  end
```

### Genre

Genre class provides an interface to traverse sub genres.

```ruby
  root = RakutenWebService::Ichiba::Genre.root # root genre
  # children returns sub genres
  root.children.each do |child|
    puts "[#{child.id}] #{child.name}"
  end

  # Use genre id to fetch genre object
  RakutenWebService::Ichiba::Genre[100316].name # => "水・ソフトドリンク"
```


### Ichiba Item Ranking

```ruby
  RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 0) # returns the TOP 30 items for Male in 30s
  RakutenWebService::Ichiba::Genre[100316].ranking # the TOP 30 items in "水・ソフトドリンク" genre
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
