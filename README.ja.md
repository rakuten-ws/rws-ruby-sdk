# RakutenWebService

[![Build Status](https://travis-ci.org/rakuten-ws/rws-ruby-sdk.png?branch=master)](https://travis-ci.org/rakuten-ws/rws-ruby-sdk)
[![Gem Version](https://badge.fury.io/rb/rakuten_web_service.png)](http://badge.fury.io/rb/rakuten_web_service)
[![Coverage Status](https://coveralls.io/repos/github/rakuten-ws/rws-ruby-sdk/badge.svg?branch=master)](https://coveralls.io/github/rakuten-ws/rws-ruby-sdk?branch=master)

rakuten\_web\_serviceは、 Rubyから楽天が提供しているAPIに簡単にアクセスできるSDK(Software Development Kit)です。

English version is [here](http://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.md).

## インストール方法

bundlerを利用したアプリケーションの場合、Gemfileに以下の1行を追加します。

```ruby
  gem 'rakuten_web_service'
```

そして`bundle`コマンドでインストール。

    $ bundle

もしくは、`gem`コマンドにより

    $ gem install rakuten_web_service

とすることでインストールできます。

現在rakuten\_web\_serviceは下記のAPIをサポートしています。

### 楽天市場API

* [Rakuten Ichiba Item Search API](http://webservice.rakuten.co.jp/api/ichibaitemsearch/)
* [Rakuten Ichiba Genre Search API](http://webservice.rakuten.co.jp/api/ichibagenresearch/)
* [Rakuten Ichiba Ranking API](http://webservice.rakuten.co.jp/api/ichibaitemranking/)
* [Rakuten Product API](http://webservice.rakuten.co.jp/api/productsearch/)


### 楽天ブックス系API

* [Rakuten Books Total Search API](http://webservice.rakuten.co.jp/api/bookstotalsearch/)
* [Rakuten Books Book Search API](http://webservice.rakuten.co.jp/api/booksbooksearch/)
* [Rakuten Books CD Search API](http://webservice.rakuten.co.jp/api/bookscdsearch/)
* [Rakuten Books DVD/Blu-ray Search API](http://webservice.rakuten.co.jp/api/booksdvdsearch/)
* [Rakuten Books ForeignBook Search API](http://webservice.rakuten.co.jp/api/booksforeignbooksearch/)
* [Rakuten Books Magazine Search API](http://webservice.rakuten.co.jp/api/booksmagazinesearch/)
* [Rakuten Books Game Search API](http://webservice.rakuten.co.jp/api/booksgamesearch/)
* [Rakuten Books Software Search API](http://webservice.rakuten.co.jp/api/bookssoftwaresearch/)
* [Rakuten Books Genre Search API](http://webservice.rakuten.co.jp/api/booksgenresearch/)

### 楽天Kobo系API

* [楽天Kobo電子書籍検索API](http://webservice.rakuten.co.jp/api/koboebooksearch/)
* [楽天Koboジャンル検索API](http://webservice.rakuten.co.jp/api/kobogenresearch/)

### 楽天レシピ系API

* [楽天レシピカテゴリ一覧API](https://webservice.rakuten.co.jp/api/recipecategorylist/)
* [楽天レシピカテゴリ別ランキングAPI](https://webservice.rakuten.co.jp/api/recipecategoryranking/)

### 楽天GORA系API

* [楽天GORAゴルフ場検索API](https://webservice.rakuten.co.jp/api/goragolfcoursesearch/)
* [楽天GORAゴルフ場詳細API](https://webservice.rakuten.co.jp/api/goragolfcoursedetail/)
* [楽天GORAプラン検索API](https://webservice.rakuten.co.jp/api/goraplansearch/)

## 使用方法

### 事前準備: アプリケーションIDの取得

楽天ウェブサービスAPIを利用の際に、アプリケーションIDが必要です。
まだ取得していない場合は、楽天ウェブサービスAPIの[アプリケーション登録](https://webservice.rakuten.co.jp/app/create)を行い、アプリケーションIDを取得してください。

### 設定

`RakutenWebService.configure` メソッドを使い、Application IDとAffiliate ID（オプション）を指定することができます。

```ruby
  RakutenWebService.configure do |c|
    c.application_id = 'YOUR_APPLICATION_ID'
    c.affiliate_id = 'YOUR_AFFILIATE_ID'
  end
```

`'YOUR_APPLICATION_ID'` と `'YOUR_AFFILIATE_ID'` は、実際のアプリケーションIDとアフィリエイトIDに置き換えてください。

### 市場商品の検索

```ruby
  items = RakutenWebService::Ichiba::Item.search(:keyword => 'Ruby') # This returns Enumerable object
  items.first(10).each do |item|
    puts "#{item['itemName']}, #{item.price} yen" # You can refer to values as well as Hash.
  end
```

### ジャンル

Genreクラスは、`children`や`parent`といったジャンル階層を辿るインターフェースを持っています。

```ruby
  root = RakutenWebService::Ichiba::Genre.root # root genre
  # children returns sub genres
  root.children.each do |child|
    puts "[#{child.id}] #{child.name}"
  end

  # Use genre id to fetch genre object
  RakutenWebService::Ichiba::Genre[100316].name # => "水・ソフトドリンク"
```


### 市場商品ランキング

```ruby
  ranking_by_age = RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 1) # 30代男性 のランキングTOP 30
  ranking_by_age.each do |ranking|
    # 'itemName'以外の属性については右記を参照 http://webservice.rakuten.co.jp/api/ichibaitemsearch/#outputParameter
    puts ranking['itemName']
  end

  ranking_by_genre = RakutenWebService::Ichiba::Genre[200162].ranking # "水・ソフトドリンク" ジャンルのTOP 30
  ranking_by_genre.each do |ranking|
    puts ranking['itemName']
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
