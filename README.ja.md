# RakutenWebService

[![Gem Version](https://badge.fury.io/rb/rakuten_web_service.png)](http://badge.fury.io/rb/rakuten_web_service)
[![Coverage Status](https://coveralls.io/repos/github/rakuten-ws/rws-ruby-sdk/badge.svg?branch=master)](https://coveralls.io/github/rakuten-ws/rws-ruby-sdk?branch=master)

rakuten\_web\_serviceは、 Rubyから楽天が提供しているAPIに簡単にアクセスできるSDK(Software Development Kit)です。

English version is [here](http://github.com/rakuten-ws/rws-ruby-sdk/blob/master/README.md).

## 前提条件

* Ruby 2.7 またはそれ以上のバージョンであること

## インストール方法

bundlerを利用したアプリケーションの場合、Gemfileに以下の1行を追加します。

```ruby
gem 'rakuten_web_service'
```

そして`bundle`コマンドでインストール。

```sh
bundle
```

もしくは、`gem`コマンドにより

```sh
gem install rakuten_web_service
```

とすることでインストールできます。

現在rakuten\_web\_serviceは下記のAPIをサポートしています。

## 使用方法

### 事前準備: アプリケーションIDの取得

楽天ウェブサービスAPIを利用の際に、アプリケーションIDが必要です。
まだ取得していない場合は、楽天ウェブサービスAPIの[アプリケーション登録](https://webservice.rakuten.co.jp/app/create)を行い、アプリケーションIDを取得してください。

### 設定

`RakutenWebService.configure` メソッドを使い、Application IDとAffiliate ID（オプション）を指定することができます。

```ruby
  RakutenWebService.configure do |c|
    # (必須) アプリケーションID
    c.application_id = 'YOUR_APPLICATION_ID'

    # (任意) 楽天アフィリエイトID
    c.affiliate_id = 'YOUR_AFFILIATE_ID' # default: nil

    # (任意) リクエストのリトライ回数
    # 一定期間の間のリクエスト数が制限を超えた時、APIはリクエスト過多のエラーを返す。
    # その後、クライアントは少し間を空けた後に同じリクエストを再度送る。
    c.max_retries = 3 # default: 5

    # (任意) デバッグモード
    # trueの時、クライアントはすべてのHTTPリクエストとレスポンスを
    # 標準エラー出力に流す。
    c.debug = true # default: false
  end
```

`'YOUR_APPLICATION_ID'` と `'YOUR_AFFILIATE_ID'` は、実際のアプリケーションIDとアフィリエイトIDに置き換えてください。

#### 環境変数

`application_id` と `affiliate_id` はそれぞれ、環境変数`RWS_APPLICATION_ID`と`RWS_AFFILIATE_ID`を定義することでも設定できる。

### 市場商品の検索

```ruby
  items = RakutenWebService::Ichiba::Item.search(keyword:  'Ruby') # Enumerable オブジェクトが返ってくる
  items.first(10).each do |item|
    puts "#{item['itemName']}, #{item.price} yen" # Hashのように値を参照できる
  end
```

### ページング

`RakutenWebService::Ichiba::Item.search` など`search`メソッドはページングのためのメソッドを持ったオブジェクトを返します。

```ruby
  items = RakutenWebService::Ichiba::Item.search(keyword: 'Ruby')
  items.count #=> 30. デフォルトで1度のリクエストで30件の商品情報が返ってくる

  last_items = items.page(3) # 3ページ目の情報を取る

  # 最後のページまでスキップする
  while last_items.next_page?
    last_items = last_items.next_page
  end

  # 最後のページの商品名を表示
  last_items.each do |item|
    puts item.name
  end

  # 上記の処理をより簡潔に書くと以下のようになる
  items.page(3).all do |item|
    puts item.name
  end
```

### ジャンル

Genreクラスは、`children`や`parent`といったジャンル階層を辿るインターフェースを持っています。

```ruby
  root = RakutenWebService::Ichiba::Genre.root # ジャンルのルート
  # children はそのジャンルの直下のサブジャンルを返す
  root.children.each do |child|
    puts "[#{child.id}] #{child.name}"
  end

  # ジャンルの情報を引くため、ジャンルIDを用る
  RakutenWebService::Ichiba::Genre[100316].name # => "水・ソフトドリンク"
```

### 市場商品ランキング

```ruby
  ranking_by_age = RakutenWebService::Ichiba::Item.ranking(:age => 30, :sex => 1) # 30代女性 のランキングTOP 30
  ranking_by_age.each do |ranking|
    # 'itemName'以外の属性については右記を参照 https://webservice.rakuten.co.jp/documentation/ichiba-item-ranking#outputParameter
    puts ranking.name
  end

  ranking_by_genre = RakutenWebService::Ichiba::Genre[200162].ranking # "水・ソフトドリンク" ジャンルのTOP 30
  ranking_by_genre.each do |ranking|
    puts ranking.name
  end
```

### レシピ

```ruby
  categories = RakutenWebService::Recipe.small_categories

  # 全種類の小カテゴリーを表示
  categories.each do |category|
    category.name
  end

  recipes = categories.first.ranking

  # カテゴリーに対応するレシピを表示
  recipes.each do |recipe|
    recipe.title
  end
```

## サポートしているAPI

### 楽天市場API

* [Rakuten Ichiba Item Search API](https://webservice.rakuten.co.jp/documentation/ichiba-item-search/)
* [Rakuten Ichiba Genre Search API](https://webservice.rakuten.co.jp/documentation/ichiba-genre-search/)
* [Rakuten Ichiba Ranking API](https://webservice.rakuten.co.jp/documentation/ichiba-item-ranking/)
* [Rakuten Product API](https://webservice.rakuten.co.jp/documentation/ichiba-product-search/)
* [Rakuten Ichiba Tag Search API](https://webservice.rakuten.co.jp/documentation/ichiba-tag-search/)

### 楽天ブックス系API

* [Rakuten Books Total Search API](https://webservice.rakuten.co.jp/documentation/books-total-search/)
* [Rakuten Books Book Search API](https://webservice.rakuten.co.jp/documentation/books-book-search/)
* [Rakuten Books CD Search API](https://webservice.rakuten.co.jp/documentation/books-cd-search/)
* [Rakuten Books DVD/Blu-ray Search API](https://webservice.rakuten.co.jp/documentation/books-dvd-search/)
* [Rakuten Books ForeignBook Search API](https://webservice.rakuten.co.jp/documentation/books-foreign-search/)
* [Rakuten Books Magazine Search API](https://webservice.rakuten.co.jp/documentation/books-magazine-search/)
* [Rakuten Books Game Search API](https://webservice.rakuten.co.jp/documentation/books-game-search/)
* [Rakuten Books Software Search API](https://webservice.rakuten.co.jp/documentation/books-software-search/)
* [Rakuten Books Genre Search API](https://webservice.rakuten.co.jp/documentation/books-genre-search/)

### 楽天Kobo系API

* [楽天Kobo電子書籍検索API](https://webservice.rakuten.co.jp/documentation/kobo-ebook-search/)
* [楽天Koboジャンル検索API](https://webservice.rakuten.co.jp/documentation/kobo-genre-search/)

### 楽天レシピ系API

* [楽天レシピカテゴリ一覧API](https://webservice.rakuten.co.jp/documentation/recipe-category-list/)
* [楽天レシピカテゴリ別ランキングAPI](https://webservice.rakuten.co.jp/documentation/recipe-category-ranking/)

### 楽天GORA系API

* [楽天GORAゴルフ場検索API](https://webservice.rakuten.co.jp/documentation/gora-golf-course-search/)
* [楽天GORAゴルフ場詳細API](https://webservice.rakuten.co.jp/documentation/gora-golf-course-detail/)
* [楽天GORAプラン検索API](https://webservice.rakuten.co.jp/documentation/gora-plan-search/)

### 楽天トラベル系APIs

* [楽天トラベル施設検索API](https://webservice.rakuten.co.jp/documentation/simple-hotel-search/)
* [楽天トラベル地区コードAPI](https://webservice.rakuten.co.jp/documentation/get-area-class/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
