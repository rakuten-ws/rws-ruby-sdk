# RakutenWebService

[![CI](https://github.com/rakuten-ws/rws-ruby-sdk/workflows/CI/badge.svg)](https://github.com/rakuten-ws/rws-ruby-sdk/actions?query=workflow%3ACI+branch%3Amaster)
[![Gem Version](https://badge.fury.io/rb/rakuten_web_service.svg)](https://badge.fury.io/rb/rakuten_web_service)
[![Test Coverage](https://codeclimate.com/github/rakuten-ws/rws-ruby-sdk/badges/coverage.svg)](https://codeclimate.com/github/rakuten-ws/rws-ruby-sdk/coverage)
[![Code Climate](https://codeclimate.com/github/rakuten-ws/rws-ruby-sdk/badges/gpa.svg)](https://codeclimate.com/github/rakuten-ws/rws-ruby-sdk)
[![Gitter](https://badges.gitter.im/rakuten-ws/rws-ruby-sdk.svg)](https://gitter.im/rakuten-ws/rws-ruby-sdk?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

This gem provides a client for easily accessing [Rakuten Web Service APIs](https://webservice.rakuten.co.jp/).

日本語のドキュメントは[こちら](https://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.ja.md)。

## Table of Contents

* [Prerequisite](#prerequisite)
* [Installation](#installation)
* [Usage](#usage)
  * [Prerequisite: Getting Application ID](#prerequisite-getting-application-id)
  * [Configuration](#configuration)
  * [Search Ichiba Items](#search-ichiba-items)
  * [Pagerizing](#pagerizing)
  * [Genre](#genre)
  * [Ichiba Item Ranking](#ichiba-item-ranking)
* [Supported APIs](#supported-apis)
  * [Rakuten Ichiba APIs](#rakuten-ichiba-apis)
  * [Rakuten Books APIs](#rakuten-books-apis)
  * [Rakuten Kobo APIs](#rakuten-kobo-apis)
  * [Rakuten Recipe APIs](#rakuten-recipe-apis)
  * [Rakuten GORA APIs](#rakuten-gora-apis)
  * [Rakuten Travel APIs](#rakuten-travel-apis)
* [Contributing](#contributing)

## Prerequisite

* Ruby 2.7 or later

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rakuten_web_service'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install rakuten_web_service
```

## Usage

### Prerequisite: Getting Application ID

You need to get Application ID for your application to access to Rakuten Web Service APIs.
If you have not got it, register your application [here](https://webservice.rakuten.co.jp/app/create).

### Configuration

At first, you have to specify your application's key. And you can tell the client your afiiliate id with `RakutenWebService.configure`.

#### In Your Code

```ruby
  RakutenWebService.configure do |c|
    # (Required) Appliction ID for your application.
    c.application_id = 'YOUR_APPLICATION_ID'

    # (Optional) Affiliate ID for your Rakuten account.
    c.affiliate_id = 'YOUR_AFFILIATE_ID' # default: nil

    # (Optional) # of retries to send requests when the client receives
    # When the number of requests in some period overcomes the limit, the endpoints will return
    # too many requests error. Then the client tries to retry to send the same request after a
    # while.
    c.max_retries = 3 # default: 5

    # (Optional) Enable debug mode. When set true, the client streams out all HTTP requests and
    # responses to the standard error.
    c.debug = true # default: false
  end
```

Please note that you need to replace `'YOUR_APPLICATION_ID'` and `'YOUR_AFFILIATE_ID'` with actual ones you have.

#### Environment Variables

You can configure `application_id` and `affiliate_id` by defining environment variables `RWS_APPLICATION_ID` and `RWS_AFFILIATE_ID`.

### Search Ichiba Items

```ruby
  items = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby') # This returns Enumerable object
  items.first(10).each do |item|
    puts "#{item['itemName']}, #{item.price} yen" # You can refer to values as well as Hash.
  end
```

### Pagerizing

Responses of resources' `search` such as `RakutenWebService::Ichiba::Item.search` have methods for paginating fetched resources.

```ruby
  items = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby')
  items.count #=> 30. In default, the API returns up to 30 items matched with given keywords.

  last_items = items.page(3) # Skips first 2 pages.

  # Go to the last page
  while last_items.next_page?
    last_items = last_items.next_page
  end

  # Shows the title of the last 30 items
  last_items.each do |item|
    puts item.name
  end

  # Easier way to fetch all resources page 3 and latter
  items.page(3).all do |item|
    puts item.name
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
  ranking_by_age = RakutenWebService::Ichiba::Item.ranking(age: 30, sex: 1) # returns the TOP 30 items for Male in 30s
  # For attributes other than 'itemName', see: https://webservice.rakuten.co.jp/documentation/ichibaitemsearch/#outputParameter
  ranking_by_age.each do |ranking|
    puts item.name
  end

  ranking_by_genre = RakutenWebService::Ichiba::Genre[200162].ranking # the TOP 30 items in "水・ソフトドリンク" genre
  ranking_by_genre.each do |ranking|
    puts item.name
  end
```

### Recipe

```ruby
  categories = RakutenWebService::Recipe.small_categories

  # Search all small recipe categories.
  categories.each do |category|
    category.name
  end

  recipes = categories.first.ranking

  # Search category recipes.
  recipes.each do |recipe|
    recipe.title
  end
```

## Supported APIs

Now rakuten\_web\_service is supporting the following APIs:

### Rakuten Ichiba APIs

* [Rakuten Ichiba Item Search API](https://webservice.rakuten.co.jp/documentation/ichiba-item-search/)
* [Rakuten Ichiba Genre Search API](https://webservice.rakuten.co.jp/documentation/ichiba-genre-search/)
* [Rakuten Ichiba Ranking API](https://webservice.rakuten.co.jp/documentation/ichiba-item-ranking/)
* [Rakuten Product API](https://webservice.rakuten.co.jp/documentation/ichiba-product-search/)
* [Rakuten Ichiba Tag Search API](https://webservice.rakuten.co.jp/documentation/ichiba-tag-search/)

### Rakuten Books APIs

* [Rakuten Books Total Search API](https://webservice.rakuten.co.jp/documentation/books-total-search/)
* [Rakuten Books Book Search API](https://webservice.rakuten.co.jp/documentation/books-book-search/)
* [Rakuten Books CD Search API](https://webservice.rakuten.co.jp/documentation/books-cd-search/)
* [Rakuten Books DVD/Blu-ray Search API](https://webservice.rakuten.co.jp/documentation/books-dvd-search/)
* [Rakuten Books ForeignBook Search API](https://webservice.rakuten.co.jp/documentation/books-foreign-search/)
* [Rakuten Books Magazine Search API](https://webservice.rakuten.co.jp/documentation/books-magazine-search/)
* [Rakuten Books Game Search API](https://webservice.rakuten.co.jp/documentation/books-game-search/)
* [Rakuten Books Software Search API](https://webservice.rakuten.co.jp/documentation/books-software-search/)
* [Rakuten Books Genre Search API](https://webservice.rakuten.co.jp/documentation/books-genre-search/)

### Rakuten Kobo APIs

* [Rakuten Kobo Ebook Search API](https://webservice.rakuten.co.jp/documentation/kobo-ebook-search/)
* [Rakuten Kobo Genre Search API](https://webservice.rakuten.co.jp/documentation/kobo-genre-search/)

### Rakuten Recipe APIs

* [Rakuten Recipe Category List API](https://webservice.rakuten.co.jp/documentation/recipe-category-list/)
* [Rakuten Recipe Category Ranking API](https://webservice.rakuten.co.jp/documentation/recipe-category-ranking/)

### Rakuten GORA APIs

* [Rakuten GORA Golf Course Search API](https://webservice.rakuten.co.jp/documentation/gora-golf-course-search/)
* [Rakuten GORA Golf Course Detail Search API](https://webservice.rakuten.co.jp/documentation/gora-golf-course-detail/)
* [Rakuten GORA Plan Search API](https://webservice.rakuten.co.jp/documentation/gora-plan-search/)

### Rakuten Travel APIs

* [Rakuten Travel Simple Hotel API](https://webservice.rakuten.co.jp/documentation/simple-hotel-search/)
* [Rakuten Travel Get Area Class API](https://webservice.rakuten.co.jp/documentation/get-area-class/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
